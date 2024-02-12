import type { JestConfigWithTsJest } from "ts-jest";
import { defaultsESM as tsjPreset } from "ts-jest/presets";

const jestConfig: JestConfigWithTsJest = {
  preset: "ts-jest",
  testEnvironment: "node",
  ...tsjPreset,
};
export default jestConfig;
