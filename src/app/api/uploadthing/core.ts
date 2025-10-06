import { createUploadthing, type FileRouter } from "uploadthing/next";
import { UploadThingError } from "uploadthing/server";

const f = createUploadthing({
  errorFormatter: (err) => {
    console.log("UploadThing Error:", err);
    return { message: err.message };
  },
});

// Simplified auth function - replace with your actual auth logic
const auth = async (req: Request) => {
  // TODO: Replace with your actual authentication
  const { userId } = await auth();
  if (!userId) throw new Error("Unauthorized");
  return { id: "fakeId" };
};

// FileRouter for your app, can contain multiple FileRoutes
export const ourFileRouter = {
  imageUploader: f({
    image: {
      maxFileSize: "4MB",
      maxFileCount: 1,
    },
  }).onUploadComplete(async ({ file }) => {
    // Simplified - just return the URL
    console.log("Upload complete!");
    console.log("file url", file.url);

    return {
      url: file.url,
    };
  }),
} satisfies FileRouter;

export type OurFileRouter = typeof ourFileRouter;
