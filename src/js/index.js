import css from "/src/css/main.css?inline";
import { Elm } from "/src/Main.elm";

const styles = document.createElement("style");
styles.innerHTML = css;

document.head.prepend(styles);

const chime1 = new Audio("/chime1.mp3");
const chime2 = new Audio("/chime2.mp3");

const audioCtx = new (window.AudioContext || window.webkitAudioContext)();

const app = Elm.Main.init({});

const noise = (noise) => {
  if (audioCtx) {
    audioCtx.resume();
    if (noise.paused) {
      noise.play();
    } else {
      noise.currentTime = 0;
    }
  } else {
    console.log("oops not AudioContext");
  }
};

app.ports.noise.subscribe((msg) => {
  if (msg === 1) {
    noise(chime1);
  } else {
    noise(chime2);
  }
});
