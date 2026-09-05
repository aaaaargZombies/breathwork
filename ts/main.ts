import { Elm } from "~/elm/Main.elm";
import "~/src/style.css";

const app = Elm.Main.init({
  node: document.querySelector("#elm-app"),
});
