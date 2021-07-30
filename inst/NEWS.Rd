\name{NEWS}
\title{News for Package \pkg{RcppAnnoy}}
\newcommand{\ghpr}{\href{https://github.com/eddelbuettel/rcppannoy/pull/#1}{##1}}
\newcommand{\ghit}{\href{https://github.com/eddelbuettel/rcppannoy/issues/#1}{##1}}

\section{Changes in version 0.0.19 (2021-07-30)}{
  \itemize{
    \item Minor tweaks to default CI setup and DESCRIPTION file
  }
}

\section{Changes in version 0.0.18 (2020-12-15)}{
  \itemize{
    \item Small tweaks to threading policy header defines (Dirk closing
    \ghit{65})
    \item Vignette code is again compiled during testing (Aaron Lum and
    Dirk in \ghpr{66} addressing \ghit{64})
    \item Upstream code (with Aaron's PR) was synchronized once more
    (Dirk in \ghpr{67})
    \item A new helper function was added to report the Annoy version
    (Aaron in \ghpr{68})
  }
}

\section{Changes in version 0.0.17 (2020-11-15)}{
  \itemize{
    \item Upgrade to Annoy 1.17, but default to serial use.
    \item Add new header file to regroup includes and defines.
    \item Upgrade CI script to use R with bspm on focal.
  }
}

\section{Changes in version 0.0.16 (2020-03-06)}{
  \itemize{
    \item Use \code{int} in two interfaces (Dirk in \ghpr{59} for upstream
    PR 460 and closing \ghit{56}).
    \item Use \code{inline} for two helper functions (Dirk in \ghpr{59}
    for upstream PR 461 and closing \ghit{57}; also Aaron in \ghpr{58}
    after earlier discussion).
    \item Removed a noisy \code{pragma} (Dirk in \ghpr{60} for upstream
    PR 462).
    \item Add a simple helper function displaying compiler status.
  }
}

\section{Changes in version 0.0.15 (2020-02-25)}{
  \itemize{
    \item RcppAnnoy synchronized with upstream PR 455 (Dirk in \ghpr{55}).
    \item The help page has a small correction thanks to Bill1 Venables.
    \item The \code{alloca()} function is now declared portably thanks
    to a working example in \emph{Writing R Extensions}.
  }
}

\section{Changes in version 0.0.14 (2019-11-11)}{
  \itemize{
    \item RcppAnnoy again synchronized with upstream to ensure builds with
    older compilers without AVX512 instructions (Dirk \ghpr{53}). 
    \item The \code{cleanup} script only uses \code{/bin/sh}.
  }
}

\section{Changes in version 0.0.13 (2019-09-23)}{
  \itemize{
    \item In example(), the saved and loaded filename is now obtained
    via tempfile() to not touch user directories per CRAN Policy (Dirk).
    \item RcppAnnoy was again synchronized with Annoy upstream leading
    to enhanced performance and more features (Dirk \ghpr{48}).
    \item Minor changes made (and send as PRs upstream) to adapt both
    \code{annoylib.h} and \code{mman.h} changes (Dirk).
    \item A spurious command was removed from one vignette (Peter Hickey
    in \ghpr{49}).
    \item Two new user-facing functions onDiskBuild() and unbuild() were
    added (Dirk in \ghpr{50}).
    \item Minor tweaks were made to two tinytest-using test files (Dirk).
  }
}
  
\section{Changes in version 0.0.12 (2019-05-12)}{
  \itemize{
    \item Allow setting of seed (Dirk in \ghpr{41} fixing \ghit{40}).
    \item Document \code{setSeed} (James Melville in \ghpr{42}
    documenting \ghit{41}).
    \item Added documentation (Adam Spannbauer in \ghpr{44} closing
    \ghit{43}).
    \item Switched unit testing to the new \pkg{tinytest} package (Dirk
    in \ghpr{45}).
    \item The vignette is now pre-made in included as-is in Sweave
    document reducing the number of suggested packages.
  }
}

\section{Changes in version 0.0.11 (2018-10-30)}{
  \itemize{
    \item Synchronized with Annoy upstream (\ghpr{26}, \ghpr{30}, \ghpr{36}).
    \item Added new Hamming distance measure functionality; should be
    considered experimental as the functionality depends on integer values.
    \item Travis CI use was updated to the R 3.5 PPA (\ghpr{28})
    \item New vignette about Annoy use from C++ via Rcpp (Aaron Lun
    in \ghpr{29} addressing \ghit{19}; also \ghpr{32}, \ghpr{33})
    \item The vignette was rewritten using \pkg{pinp} (\ghpr{34}, \ghpr{35}).
  }
}

\section{Changes in version 0.0.10 (2017-09-25)}{
  \itemize{
    \item The \code{getItemsVector()} function no longer crashes (\ghit{24})
  }
}

\section{Changes in version 0.0.9 (2017-08-31)}{
  \itemize{
    \item Synchronized with Annoy upstream version 1.9.1
    \item Minor updates in calls and tests as required by annoy 1.9.1
    \item New Manhattan distance modules along with unit test code
    \item Additional unit tests from upstream test code carried over
    \item Binary mode is used for \code{save} (as suggested by @khoran
    in \ghit{21})
    \item A new file \code{init.c} was added with calls to
    \code{R_registerRoutines()} and \code{R_useDynamicSymbols()}
    \item Symbol registration is enabled in \code{useDynLib}
  }
}

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
