(ns app.socket
  (:require ["phoenix" :as phx]))

(defn create
  []
  (new phx/Socket
       "/socket"
       {:params {:token (.-userToken js/window)}}))

(defn connect! [socket]
  (.connect socket)
  socket)

(defn join!
  [socket topic username]
  (let [channel (.channel socket topic (clj->js {:username username}))]
    (.join channel)
    channel))

(defn send!
  [channel message]
  (.push channel "message:add" (clj->js {:message message})))

(defn on!
  [entity event fn]
  (.on entity event fn)
  entity)
