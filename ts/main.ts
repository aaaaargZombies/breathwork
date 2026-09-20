import * as Strudel from "@strudel/web";
import * as SoundFonts from "./soundfonts/index";
import "~/css/style.css";
import { Elm } from "~/elm/Main.elm";
import * as Sounds from "./sounds.ts";

const app = Elm.Main.init({
  node: document.querySelector("#elm-app"),
});

const repl = await Strudel.initStrudel({
  prebake: async () => {
    await SoundFonts.registerSoundfonts();
    await Strudel.samples("github:tidalcycles/dirt-samples");
    await Strudel.samples(
      "https://raw.githubusercontent.com/felixroos/dough-samples/main/vcsl.json",
    );
    await Strudel.samples("github:bubobubobubobubo/dough-waveforms");
  },
});

repl.setCps(1);

if (app.ports && app.ports.outgoing) {
  app.ports.outgoing.subscribe(async ({ tag, data }) => {
    switch (tag) {
      case "PLAY":
        Sounds.make(repl.setCps, data).play();
        Sounds.make(data).play();
        break;

      case "STOP":
        Strudel.hush();
        break;

      default:
        exhaustive("❌ Unknown tag from Elm:", tag);
        break;
    }
  });
}

const exhaustive = (msg: string, supriseCase: never) => {
  console.error(msg, supriseCase);
};
