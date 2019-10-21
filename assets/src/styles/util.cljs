(ns styles.util)

(defn inject!
  [style]
  (let [head (or (.-head js/document)
                 (first (.getElementsByTagName js/document "head")))
        style-elem (.createElement js/document "style")]
    (set! (.-type style-elem) "text/css")
    (.appendChild style-elem (.createTextNode js/document style))
    (.appendChild head style-elem)))
