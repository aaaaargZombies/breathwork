import * as Strudel from "@strudel/web";

type Pattern = {
  "0_breatheIn": number;
  "1_holdIn": number;
  "2_breatheOut": number;
  "3_pauseOut": number;
};

const beatsPerCycle = (p: Pattern): number =>
  Object.values(p).reduce((a, b) => a + b);

const setTempo =
  // really wish strudel had types
  (setCps: any) =>
    (beatsPerCycle: number): void => {
      setCps(60 / 60 / beatsPerCycle);
    };

const buildCycle =
  (f: (entry: [string, number], index: number) => number[]) => (p: Pattern) => {
    const a = Object.entries(p)
      .filter(([_, n]) => Boolean(n))
      .flatMap(f);
    return Strudel.sequence(...a);
  };

export const make = (setCps: any, p: Pattern) => {
  setTempo(setCps)(beatsPerCycle(p));
  // plays note as many times per box key value
  // note rizes in pitch on cycle change
  const cycle = buildCycle(([_key, n], i) => Array(n).fill(i))(p);
  const counter = Strudel.note(cycle)
    .scale("C:minor")
    .sound("arpy")
    .postgain(0.2);

  // silent until first beat of cycle
  const signalChange = buildCycle(([_key, n], _i) =>
    n < 1 ? [] : [2, ...Array(n - 1).fill("~")],
  )(p);
  const dings = Strudel.note(signalChange).sound("bleep").postgain(0.9);

  return Strudel.stack(counter, dings);
};
