import { query } from "./_generated/server";
import { v } from "convex/values";

// Get unique programs for a specific athlete
export const getProgramsByAthlete = query({
  args: { athlete_name: v.string() },
  handler: async (ctx, args) => {
    const workouts = await ctx.db
      .query("workouts")
      .withIndex("by_athlete", (q) => q.eq("athlete_name", args.athlete_name))
      .collect();

    // Extract unique program names
    const programNames = new Set(workouts.map(w => w.program_name));

    return Array.from(programNames).sort();
  },
});
