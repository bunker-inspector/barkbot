
;;import {Socket} from "phoenix"
(ns socket
  (:require ["phoenix" :as phx]))

;;let socket = new Socket("/socket", {params: {token: window.userToken}})
(def socket
  (phx/Socket
   "/socket"
   {:params {:token (js/window -userToken)}}))

;;socket.connect()
(.connect socket)

;;// Now that you are connected, you can join channels with a topic:
;;let channel = socket.channel("topic:subtopic", {})
(def channel
  (.channel socket "topic/subtopic" {}))

;;channel.join()
(.join channel)

;;.receive("ok", resp => { console.log("Joined successfully", resp) })
(.receive channel "ok" #(println (str "Joined Succeessfully" %)))
;;.receive("error", resp => { console.log("Unable to join", resp) })
(.receive channel "error" #(println (str "Joined Succeessfully" %)))
;;
;;export default socket
