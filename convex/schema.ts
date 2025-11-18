import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  workouts: defineTable({
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
  })
    .index("by_athlete", ["athlete_name"])
    .index("by_athlete_program", [
      "athlete_name",
      "program_name",
    ])
    .index("by_athlete_start_date", [
      "athlete_name",
      "start_date",
    ])
    .index("by_program", ["program_name"])
    .index("by_week", ["week_number"]),
});
