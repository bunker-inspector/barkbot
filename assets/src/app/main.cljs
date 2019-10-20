(ns app.main
  (:require [reagent.core :as r :refer [atom]]))

(defn simple-component []
  [:div
   [:p "I am a component!"]])

(defn ^:dev/after-load main! []
  (println "Hello World!")
  (r/render-component
   [simple-component]
   (.getElementById js/document "app")))
