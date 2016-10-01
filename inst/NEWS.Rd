\name{NEWS}
\title{News for Package \pkg{RcppAnnoy}}
\newcommand{\ghpr}{\href{https://github.com/eddelbuettel/rcppannoy/pull/#1}{##1}}
\newcommand{\ghit}{\href{https://github.com/eddelbuettel/rcppannoy/issues/#1}{##1}}

\section{Changes in version 0.0.8 (2016-10-01)}{
  \itemize{
    \item New functions \code{getNNsByItemList} and
    \code{getNNsByVectorList}, from by Michael Phan-Ba in \ghit{12}
    \item Added destructor (PR \ghpr{14} by Michael Phan-Ba)
    \item Extended templatization (PR \ghpr{11} by Dan Dillon)
    \item Switched to \code{run.sh} for Travis (PR \ghpr{17})
    \item Added test for admissible value to \code{addItem} (PR
    \ghpr{18} closing issue \ghit{13})
  }
}

\section{Changes in version 0.0.7 (2015-11-15)}{
  \itemize{
    \item Synchronized with Annoy upstream changes
    \item Minor internal changes required by Annoy changes
  }
}

\section{Changes in version 0.0.6 (2015-05-03)}{
  \itemize{
    \item Synchronized with Annoy upstream changes
    \item Permit supplying our own RNG
    \item Minor internal changes
  }
}

\section{Changes in version 0.0.5 (2015-01-22)}{
  \itemize{
    \item Synchronized with Annoy upstream changes
  }
}

\section{Changes in version 0.0.4 (2015-01-22)}{
  \itemize{
    \item Synchronized with Annoy upstream changes
    \item Depends on R (>= 3.1) to permit C++11 builds
  }
}

\section{Changes in version 0.0.3 (2014-11-17)}{
  \itemize{
    \item Synchronized with Annoy upstream changes
    \item Windows support added (Qiang Kou in \ghpr{2})
  }
}

\section{Changes in version 0.0.2 (2014-11-13)}{
  \itemize{
    \item Added verbosity toggle
    \item Added regression tests
  }
}

\section{Changes in version 0.0.1 (2014-11-08)}{
  \itemize{
    \item Initial release
  }
}
