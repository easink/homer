// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

// let hooks = {
//   canvas: {
//     mounted() {
//       let canvas = this.el;
//       let context = canvas.getContext("2d");
//
//       Object.assign(this, { canvas, context });
//     },
//     updated() {
//       let { canvas, context } = this;
//
//       let halfHeight = canvas.height / 2;
//       let halfWidth = canvas.width / 2;
//       let smallerHalf = Math.min(halfHeight, halfWidth);
//
//       context.clearRect(0, 0, canvas.width, canvas.height);
//       context.fillStyle = "rgba(128, 0, 255, 1)";
//       context.beginPath();
//       context.arc(
//         halfWidth,
//         halfHeight,
//         smallerHalf / 16,
//         0,
//         2 * Math.PI
//       );
//       context.fill();
//     }
//   }
// };

let Hooks = {}
Hooks.UnlimitedCube = {
  mounted() {
    console.log("mounted");

    // this.el.addEventListener("transitionend", some_function.bind(this, "aaa", "bbb"), false);
    this.el.addEventListener("transitionend", function() {
        // console.log("the orientation of the device is now ");
        // this.pushEvent("transitionend", { aaa: "bbb" });
        this.pushEvent("transitionend");
    }.bind(this));

  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}});
liveSocket.connect()

// for debug
window.liveSocket = liveSocket

// in the browser's web console
// >> liveSocket.enableDebug()
