export interface WorkoutRecord {
  id?: number
  user_id: string
  athlete_name: string
  program_name: string
  start_date: string // ISO date string (YYYY-MM-DD)
  week_number: number
  day_number: number | null
  exercise_number: number
  exercise_name: string
  sets: number | null
  reps: string // Keep as string since it can be "10-15" range
  weights: number | null
  percent: number | null
  athlete_comments: string | null
  completed: boolean // Track if set is completed
  created_at?: string
  updated_at?: string
}

export interface ScrapeResponse {
  success?: boolean
  data?: WorkoutRecord[]
  count?: number
  error?: string
  suggestion?: string
  details?: string
  message?: string
}

export interface ScrapeRequest {
  url: string
  tabName: string
  athleteName?: string
}

