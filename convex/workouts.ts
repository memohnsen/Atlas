import { mutation, query } from "./_generated/server";
import { v } from "convex/values";

// Get all workouts
export const get = query({
  args: {},
  handler: async (ctx) => {
    return await ctx.db.query("workouts").collect();
  },
});

// Create a new workout entry
export const createWorkout = mutation({
  args: {
    athlete_name: v.string(),
    completed: v.boolean(),
    day_number: v.union(v.float64(), v.null()),
    exercise_name: v.string(),
    exercise_number: v.float64(),
    notes: v.string(),
    program_name: v.string(),
    reps: v.string(),
    sets: v.union(v.float64(), v.null()),
    start_date: v.string(),
    user_id: v.string(),
    week_number: v.float64(),
    weights: v.union(v.float64(), v.null()),
  },
  handler: async (ctx, args) => {
    const workoutId = await ctx.db.insert("workouts", args);
    return workoutId;
  },
});

// Get all workouts for an athlete
export const getWorkoutsByAthlete = query({
  args: { athlete_name: v.string() },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("workouts")
      .withIndex("by_athlete", (q) => q.eq("athlete_name", args.athlete_name))
      .collect();
  },
});

// Get workouts by athlete and program
export const getWorkoutsByAthleteAndProgram = query({
  args: {
    athlete_name: v.string(),
    program_name: v.string(),
  },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("workouts")
      .withIndex("by_athlete_program", (q) =>
        q.eq("athlete_name", args.athlete_name).eq("program_name", args.program_name)
      )
      .collect();
  },
});

// Get workouts by athlete and start date
export const getWorkoutsByAthleteAndStartDate = query({
  args: {
    athlete_name: v.string(),
    start_date: v.string(),
  },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("workouts")
      .withIndex("by_athlete_start_date", (q) =>
        q.eq("athlete_name", args.athlete_name).eq("start_date", args.start_date)
      )
      .collect();
  },
});

// Get workouts by program
export const getWorkoutsByProgram = query({
  args: { program_name: v.string() },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("workouts")
      .withIndex("by_program", (q) => q.eq("program_name", args.program_name))
      .collect();
  },
});

// Get workouts by week number
export const getWorkoutsByWeek = query({
  args: { week_number: v.float64() },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("workouts")
      .withIndex("by_week", (q) => q.eq("week_number", args.week_number))
      .collect();
  },
});

// Update workout completion status
export const updateWorkoutCompletion = mutation({
  args: {
    workoutId: v.id("workouts"),
    completed: v.boolean(),
  },
  handler: async (ctx, args) => {
    await ctx.db.patch(args.workoutId, { completed: args.completed });
    return args.workoutId;
  },
});

// Update workout weights
export const updateWorkoutWeights = mutation({
  args: {
    workoutId: v.id("workouts"),
    weights: v.union(v.float64(), v.null()),
  },
  handler: async (ctx, args) => {
    await ctx.db.patch(args.workoutId, { weights: args.weights });
    return args.workoutId;
  },
});

// Update workout notes
export const updateWorkoutNotes = mutation({
  args: {
    workoutId: v.id("workouts"),
    notes: v.string(),
  },
  handler: async (ctx, args) => {
    await ctx.db.patch(args.workoutId, { notes: args.notes });
    return args.workoutId;
  },
});

// Delete a workout
export const deleteWorkout = mutation({
  args: { workoutId: v.id("workouts") },
  handler: async (ctx, args) => {
    await ctx.db.delete(args.workoutId);
  },
});

// Get a specific workout by ID
export const getWorkout = query({
  args: { workoutId: v.id("workouts") },
  handler: async (ctx, args) => {
    return await ctx.db.get(args.workoutId);
  },
});
