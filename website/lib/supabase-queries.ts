import { supabase } from './supabase';
import { WorkoutRecord } from '@/types/workout';
import { ProgramDay } from '@/types/program-workout';

/**
 * Extract unique day records from workout data
 */
function extractProgramDays(workouts: Omit<WorkoutRecord, 'id' | 'created_at' | 'updated_at'>[]): Omit<ProgramDay, 'id' | 'created_at' | 'updated_at'>[] {
  const uniqueDays = new Map<string, Omit<ProgramDay, 'id' | 'created_at' | 'updated_at'>>();

  workouts.forEach(workout => {
    // Skip if day_number is null
    if (workout.day_number === null) return;

    const key = `${workout.user_id}-${workout.athlete_name}-${workout.program_name}-${workout.start_date}-${workout.week_number}-${workout.day_number}`;

    if (!uniqueDays.has(key)) {
      uniqueDays.set(key, {
        user_id: workout.user_id,
        athlete_name: workout.athlete_name,
        program_name: workout.program_name,
        start_date: workout.start_date,
        week_number: workout.week_number,
        day_number: workout.day_number,
        completed: false,
        rating: null
      });
    }
  });

  return Array.from(uniqueDays.values());
}

/**
 * Insert a single workout record
 */
export async function insertWorkout(workout: Omit<WorkoutRecord, 'id' | 'created_at' | 'updated_at'>) {
  const { data, error } = await supabase
    .from('program_workouts')
    .insert([workout])
    .select()
    .single();

  if (error) {
    console.error('Error inserting workout:', error);
    throw error;
  }

  // Also create program_days record for this day if it doesn't exist
  if (workout.day_number !== null) {
    const programDay: Omit<ProgramDay, 'id' | 'created_at' | 'updated_at'> = {
      user_id: workout.user_id,
      athlete_name: workout.athlete_name,
      program_name: workout.program_name,
      start_date: workout.start_date,
      week_number: workout.week_number,
      day_number: workout.day_number,
      completed: false,
      rating: null
    };

    const { error: programError } = await supabase
      .from('program_days')
      .upsert(programDay, {
        onConflict: 'user_id,athlete_name,program_name,start_date,week_number,day_number',
        ignoreDuplicates: true
      });

    if (programError) {
      console.error('Error creating program day record:', programError);
      // Don't throw - workout was created successfully
    }
  }

  return data;
}

/**
 * Insert multiple workout records and create corresponding program_workout records
 */
export async function insertManyWorkouts(workouts: Omit<WorkoutRecord, 'id' | 'created_at' | 'updated_at'>[]) {
  // Insert workouts
  const { data, error } = await supabase
    .from('program_workouts')
    .insert(workouts)
    .select();

  if (error) {
    console.error('Error inserting workouts:', error);
    throw error;
  }

  // Extract unique days and create program_days records
  const programDays = extractProgramDays(workouts);

  if (programDays.length > 0) {
    const { error: programError } = await supabase
      .from('program_days')
      .upsert(programDays, {
        onConflict: 'user_id,athlete_name,program_name,start_date,week_number,day_number',
        ignoreDuplicates: true
      });

    if (programError) {
      console.error('Error creating program day records:', programError);
      // Don't throw - workouts were created successfully
    }
  }

  return data;
}

/**
 * Get all unique athletes
 */
export async function getAthletes() {
  const { data, error } = await supabase
    .from('program_workouts')
    .select('athlete_name')
    .order('athlete_name');

  if (error) {
    console.error('Error fetching athletes:', error);
    throw error;
  }

  // Get unique athlete names
  const uniqueAthletes = [...new Set(data.map(item => item.athlete_name))];
  return uniqueAthletes;
}

/**
 * Get all programs for a specific athlete
 */
export async function getProgramsForAthlete(athleteName: string) {
  const { data, error } = await supabase
    .from('program_workouts')
    .select('program_name, start_date')
    .eq('athlete_name', athleteName)
    .order('start_date', { ascending: false });

  if (error) {
    console.error('Error fetching programs:', error);
    throw error;
  }

  // Get unique program/start_date combinations
  const uniquePrograms = Array.from(
    new Map(
      data.map(item => [`${item.program_name}-${item.start_date}`, item])
    ).values()
  );

  return uniquePrograms;
}

/**
 * Get all workouts for a specific athlete and program
 */
export async function getWorkoutsForAthleteProgram(athleteName: string, programName: string) {
  const { data, error } = await supabase
    .from('program_workouts')
    .select('*')
    .eq('athlete_name', athleteName)
    .eq('program_name', programName)
    .order('week_number')
    .order('day_number', { nullsFirst: false })
    .order('exercise_number');

  if (error) {
    console.error('Error fetching workouts:', error);
    throw error;
  }

  return data as WorkoutRecord[];
}

/**
 * Check if a program already exists for an athlete
 */
export async function checkProgramExists(athleteName: string, programName: string) {
  const { data, error } = await supabase
    .from('program_workouts')
    .select('id')
    .eq('athlete_name', athleteName)
    .eq('program_name', programName)
    .limit(1);

  if (error) {
    console.error('Error checking program existence:', error);
    throw error;
  }

  return data.length > 0;
}

/**
 * Update a workout's completed status
 */
export async function updateWorkoutCompleted(id: number, completed: boolean) {
  const { data, error } = await supabase
    .from('program_workouts')
    .update({ completed })
    .eq('id', id)
    .select()
    .single();

  if (error) {
    console.error('Error updating workout:', error);
    throw error;
  }

  return data;
}

/**
 * Update a workout's athlete comments
 */
export async function updateAthleteComments(id: number, athleteComments: string | null) {
  const { data, error } = await supabase
    .from('program_workouts')
    .update({ athlete_comments: athleteComments })
    .eq('id', id)
    .select()
    .single();

  if (error) {
    console.error('Error updating athlete comments:', error);
    throw error;
  }

  return data;
}

/**
 * Delete all workouts for a specific program
 */
export async function deleteProgram(athleteName: string, programName: string) {
  const { error } = await supabase
    .from('program_workouts')
    .delete()
    .eq('athlete_name', athleteName)
    .eq('program_name', programName);

  if (error) {
    console.error('Error deleting program:', error);
    throw error;
  }

  return true;
}
