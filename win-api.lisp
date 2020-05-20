(in-package :win-api)

;;(require :cmp)

(defparameter *p-hndl* 0)

(defun find-window (name)
  (ffi:clines "#include <windows.h>")
  (ffi:c-inline (name) (:cstring) :unsigned-int "FindWindow(0, #0)" :one-liner t))

(defun get-thread-pid (hwnd)
  (ffi:clines "#include <windows.h>")
  (ffi:c-inline (hwnd) (:unsigned-int) :unsigned-int "{
HWND hand = (HWND)#0;
long thread_pid = 0;
GetWindowThreadProcessId(hand, &thread_pid); 
@(return)=thread_pid;
}"))

(defun open-process (dw-pid)
  (ffi:clines "#include <windows.h>")
  (ffi:c-inline (dw-pid) (:unsigned-int) :unsigned-int
                "OpenProcess(PROCESS_ALL_ACCESS, FALSE, #0)" :one-liner t))

(defun get-process-handle (process-name)
  (open-process (get-thread-pid (find-window process-name))))

(defun close-handle (handle)
  (ffi:clines "#include <windows.h>")
  (ffi:c-inline (handle)
                (:unsigned-int)
                :bool
                "CloseHandle(#0)" :one-liner t))

(defun release-process ()
  (if (not (eql *p-hndl* 0))
      (progn (close-handle *p-hndl*)
             (setf *p-hndl* 0))))


(defun set-process (process-name)
  (progn
    (release-process)
    (setf *p-hndl* (get-process-handle process-name))))

(defun read-process-mem (handle base-addr buf size)
  (ffi:clines "#include <windows.h>")
  (ffi:c-inline (handle base-addr buf size)
                (:unsigned-int :uint32-t :cstring :uint64-t)
                :cstring
                "{
bool complete = ReadProcessMemory(#0, #1, #2, #3, NULL);
@(return)=#2;
}"))

(defun read-address (address num-bytes)
  (ffi:with-cstring (c-buf "")
    (read-process-mem *p-hndl* address c-buf num-bytes)))

(defun write-process-mem (handle base-addr buf)
  (ffi:clines "#include <windows.h>")
  (ffi:c-inline (handle base-addr buf)
                (:unsigned-int :uint32-t :cstring)
                :bool
                "WriteProcessMemory(#0, #1, #2, sizeof(#2), NULL)" :one-liner t))

(defun write-address (address entry)
  (write-process-mem *p-hndl* address entry))


