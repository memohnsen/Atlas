import { query } from "./_generated/server";

// Get all unique athlete names
export const getUniqueAthletes = query({
  args: {},
  handler: async (ctx) => {
    const workouts = await ctx.db.query("workouts").collect();

    // Extract unique athlete names
    const athleteNames = new Set(workouts.map(w => w.athlete_name));

    return Array.from(athleteNames).sort();
  },
});
