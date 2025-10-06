import { createRouteHandler } from "uploadthing/next";
import { ourFileRouter } from "./core";

// Create the route handler with proper configuration
export const { GET, POST } = createRouteHandler({
  router: ourFileRouter,
  config: {
    token: process.env.UPLOADTHING_TOKEN,
  },
});
