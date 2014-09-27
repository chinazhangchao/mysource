(defun ask-num()
  (format t "Please enter a number:")
  (let ((val (read)))
    (if (numberp val)
      val
      (ask-num))))

