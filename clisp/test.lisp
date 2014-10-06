(defun ask-num()
  (format t "Please enter a number:")
  (let ((val (read)))
    (if (numberp val)
      val
      (ask-num))))

(defun show-squares (start end)
  (do ((i start (+ i 1)))
    ((> i end) (format t "test") 'done)
    (format t "~A ~A ~%" i (* i i))))

(defun show-squares (i end)
  (if (> i end)
    'done
    (progn 
      (format t "~A ~A ~%" i (* i i))
      (show-squares (+ i 1) end))))

(defun our-length(lst)
  (let ((len 0))
    (dolist (obj lst)
      (setf len (+ len 1)))
    len))

(defun our-length(lst number)
  (if (null lst)
    number
    (our-length (cdr lst) (+ number 1))))

(defun lstLen(lst)
  (our-length lst 0))

(defun our-copy-list(lst)
  (if (atom lst)
    lst
    (cons (car lst) (our-copy-list (cdr lst)))))

(defun our-copy-tree(tr)
  (if (atom tr)
    tr
    (cons (our-copy-tree (car tr))
          (our-copy-tree (cdr tr)))))

(defun mirror?(s)
  (let ((len (length s)))
    (and (evenp len)
      (let ((mid (/ len 2)))
        (equal (subseq s 0 mid)
          (reverse (subseq s mid)))))))

(defun second-word(str)
  (let ((p1 (+ (position #\  str) 1)))
    (subseq str p1 (position #\  str :start p1))))
