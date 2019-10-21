(ns app.util)

(defn event->value
  [event]
  (-> event .-target .-value))

(defn resetter
  [state]
  (fn [event]
    (reset! state (event->value event))))

(defn on-key-down
  [k callback]
  (fn [e]
    (when (= k (.-key e))
      (callback))))
