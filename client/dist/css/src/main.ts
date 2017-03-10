let init = () => {
  let socket = new WebSocket("ws://" + window.location.host);
  let send = (msg: String) => {
    console.log("sending: " + msg)
    socket.send(msg);
  }
  socket.addEventListener("message",(ev) => {
    let s: String = ev.data.toString();
    console.log("received: " + s);
    setTimeout(() => send("Ping"),1000);
  })
  socket.addEventListener("open",() => send("Ping!"))
}

let orsc = () => {
  if (document.readyState == "interactive" || document.readyState == "complete") {
    init();
    document.removeEventListener("readystatechange",orsc);
  }
}
document.addEventListener("readystatechange",orsc);
orsc();