(ns styles.main
  (:require [garden.core :refer [css]]
            [styles.util :as u]))

(->
 (css
  [:#join-channel-prompt
   {:display "flex"
    :width "500px"
    :margin "auto"
    :alignment "center"}]

  [:#message-input
   {:display "flex"
    :position "absolute"
    :width "99%"
    :bottom "10px"
    :flex-direction "row"}]

  [:.msg-view
   {:display "flex"
    :flex-direction "column"}]

  [:.msg-view-uname
   {:font-size "28px"}]

  [:.msg-view-row
   {}]

  [:.msg-view-row-self
   {:float "right"}]

  [:#message-input :button
   {:margin-left "8px"}])




 (u/inject!))

