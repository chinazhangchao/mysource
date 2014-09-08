(defn blank? [str]
	(every? #(Character/isWhitespace %) str))