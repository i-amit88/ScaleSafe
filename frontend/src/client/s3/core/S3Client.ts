import { S3Client } from "@aws-sdk/client-s3";
import config from "../../../config";

export const s3: S3Client = new S3Client({
  region: "us-east-1",
  endpoint: config.REACT_APP_STORAGE_URL,
  forcePathStyle: true,
  credentials: {
    accessKeyId: "test",
    secretAccessKey: "test",
  },
});
