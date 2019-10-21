(ns app.main
  (:require [reagent.core :as r]
            [cljs.core.async :as a]
            [app.socket :as s]
            [app.util :as u]
            [styles.main]))

(defonce app-state
  (r/atom {:message-text ""
           :channel-name ""
           :socket nil
           :channel nil
           :messages []
           :username ""}))

(def socket (r/cursor app-state [:socket]))
(def channel (r/cursor app-state [:channel]))
(def message-text (r/cursor app-state [:message-text]))
(def messages (r/cursor app-state [:messages]))
(def username (r/cursor app-state [:username]))

(defn send []
  (s/send! @channel @message-text)
  (reset! message-text ""))

(defn handle-message
  [message]
  (swap! messages conj [(.now js/Date)
                        (.-username message)
                        (.-message message)]))

(defn join
  []
  (let [socket* (swap! socket s/create @username)]
    (swap! socket s/connect!)
    (reset! channel (s/join! socket* "room:lobby" @username))
    (swap! channel s/on! "room:lobby:new_message" handle-message)))

(defn join-channel-prompt []
  [:span {:id "join-channel-prompt"}
   [:input {:type "text"
            :class "form-control"
            :placeholder "Pick a username"
            :value @username
            :on-key-press (when-not (empty? @username)
                            (u/on-key-down "Enter" join))
            :autoComplete "off"
            :on-change (u/resetter username)}]
   [:button {:class "btn btn-outline-success"
             :on-click join
             :disabled (empty? @username)}
    "join"]])

(defn message-view []
  [:div {:class "msg-view"}
   (for [[ts username' message] @messages]
     ^{:key ts} [:div
                 [:span {:class (str (if (= username' @username)
                                       "msg-view-row-self"
                                       "msg-view-row"))}
                  [:span {:class "msg-view-uname"} username']
                  [:span {:class "msg-view-colon"} ": "]
                  [:div {:class "msg-view-msg"} message]]])])

(defn message-input []
  [:span {:id "message-input"}
   [:input {:type "text"
            :class "form-control"
            :placeholder "Send a message..."
            :value @message-text
            :on-key-press (when-not (empty? @message-text)
                            (u/on-key-down "Enter" send))
            :autoComplete "off"
            :on-change (u/resetter message-text)}]
   [:button {:class "btn btn-outline-success"
             :disabled (empty? @message-text)
             :on-click send}
    "send"]])

(defn app []
  (if (some? @channel)
    [:div (message-view) (message-input)]
    (join-channel-prompt)))

(defn ^:dev/after-load main!
  []
  (r/render
   [app]
   (.getElementById js/document "app")))
