import { test, expect } from "vitest";
import * as Hegel from "@hegeldev/hegel";
import * as Generator from "@hegeldev/hegel/generators";

test("An array reversed twice is the same", () =>
  Hegel.test((testCase) => {
    const vec1 = testCase.draw(
      Generator.arrays(Generator.integers(), { minSize: 2, unique: true }),
    );
    const vec2 = [...vec1].reverse().reverse();
    const vec3 = [...vec1].reverse();

    expect(vec1).toEqual(vec2);
    expect(vec1).not.toEqual(vec3);
  }));

const add = (a: number, b: number): number => a + b;

test("Addition", () =>
  Hegel.test((testCase) => {
    const a = testCase.draw(Generator.integers());
    const b = testCase.draw(Generator.integers());
    expect(add(a, b)).toEqual(add(b, a));
  }));
