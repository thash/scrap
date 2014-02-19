(ns rindo.core
  (:use [clojure.java.shell :only [sh]]))

(def ^:dynamic *server* "navi-s")

(defn rsh [cmd & opts]
  (let [hash-opts (when opts (apply hash-map opts))
        _cmd (if (:cd hash-opts)
               (str "cd " (:cd hash-opts) " && " cmd) cmd)]
  (sh "ssh" *server* _cmd)))

(defn pkg
  ([name] (rsh (str "sudo apt-get -y install " name)))
  ([name & more] (do (pkg name) (pkg more))))

(pkg "git")


(defn dir [dir-name & opts]
  "TODO: sexp for dir"
  (let [hash-opts (when opts (apply hash-map opts))]
    (rsh (str "mkdir -p " dir-name))))

(defn file [file-name & opts]
  )

(rsh "whoami")
(rsh "pwd" :cd "~/.ssh/")


