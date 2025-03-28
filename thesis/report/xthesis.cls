%% ***************************************************************************
%% xthesis.cls
%% Walter Dal'Maz Silva
%% 
%% Summary of references:
%% * Allow cross platform conditionals
%% - tex.stackexchange.com/questions/288892
%%
%% * Remove French-style footnotes
%% - latex-community.org/forum/viewtopic.php?t=18235
%%
%% * Title-spacing format
%% - tex.stackexchange.com/questions/108684
%%
%% * Format table rows
%% - tex.stackexchange.com/questions/4811
%%
%% * Avoid number overlapping with text in lists:
%% - tex.stackexchange.com/questions/87019
%% - tex.stackexchange.com/questions/22983
%%
%% * Cover page based on
%% - tex.stackexchange.com/questions/125383
%% ***************************************************************************

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{xthesis}[2016/10/04 v0.1]

%% ***************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cross platform control
%% ***************************************************************************

\RequirePackage{ifplatform}

%% ***************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Set language
%% ***************************************************************************

\DeclareOption{english}{%
  \AtEndOfPackage{%
    \InputIfFileExists{xthesis_en.def}{}{%
    \ClassError{xthesis}{English definition file 'xthesis_en.def' not found}%
     {The file should be inside the xthesis folder.\MessageBreak
    Try to re-install the xthesis class.}}%
  }%
}
\DeclareOption{french}{%
  \AtEndOfPackage{%
    \InputIfFileExists{xthesis_fr.def}{}{%
    \ClassError{xresume}{French definition file 'xthesis_fr.def' not found}%
     {The file should be inside the xthesis folder.\MessageBreak
    Try to re-install the xthesis class.}}%
  }%
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{xreport}}
\ExecuteOptions{french}
\ProcessOptions\relax

\iflinux
  \LoadClass[11pt]{xreport}
\else
  \LoadClass[11pt]{xreport}
\fi

%% ***************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Required packages
%% ***************************************************************************

\RequirePackage[T1]{fontenc}

\RequirePackage{hyperref}
\hypersetup{%
  linktocpage=true,
  bookmarksopen=true,
  bookmarksnumbered=true,
  colorlinks=true,
  linkcolor=formblue,
  citecolor=formblue,
}

\RequirePackage{bookmark}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage[most]{tcolorbox}

\ifxetex
  \RequirePackage{mathspec}
  \RequirePackage[frenchb]{babel}
  \frenchbsetup{
     FrenchFootnotes    = false,
     AutoSpaceFootnotes = false
  }
  \RequirePackage[hang,flushmargin]{footmisc}
  
  \iflinux
    \setmainfont{DejaVu Sans}
    \setmathsfont(Digits,Latin,Greek){DejaVu Sans}
  \else
    \setmainfont{DejaVu Sans}
    \setmathsfont(Digits,Latin,Greek){DejaVu Sans}
    %TODO get a fallback with Arial here
  \fi
\else
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[francais]{babel}
  \renewcommand*\sfdefault{phv}
  \renewcommand{\familydefault}{\sfdefault}
\fi

%FIXME title page is changing
\RequirePackage{geometry}
\geometry{%
  verbose,
  tmargin = 2.5cm,
  bmargin = 2.5cm,
  lmargin = 2.5cm,
  rmargin = 2.5cm
}

\RequirePackage{subfig}
\RequirePackage{array}
\RequirePackage{fancyhdr} 
\RequirePackage{booktabs}
\RequirePackage{paralist}
\RequirePackage{multirow}
\RequirePackage{graphicx}
\RequirePackage{setspace}
\RequirePackage{enumitem}

\RequirePackage{caption}
\captionsetup{
  font      = small,
  labelfont = bf,
}

\RequirePackage[toc,page]{appendix} 

\RequirePackage[sort&compress,numbers]{natbib}
\bibliographystyle{unsrtnat-fr}
\renewcommand*{\bibfont}{\footnotesize}
\setlength{\bibsep}{0.6mm}

\RequirePackage{gensymb}
\RequirePackage{array}

\RequirePackage{siunitx}
\sisetup{%
  detect-family,
  locale                   = FR,
  mode                     = text,
  separate-uncertainty     = true,
  multi-part-units         = single,
  list-final-separator     = { \translate{et} },
  list-pair-separator      = { \translate{et} },
  range-phrase             = { \translate{à} }
}

\RequirePackage{chemformula}
\setchemformula{%
  decimal-marker={,}, 
  format={\color{black}\sffamily},
}

\RequirePackage{chemfig}
\RequirePackage{etoolbox}

\RequirePackage{titlesec}
\titlespacing*{\section}
  {0pt}{2.0ex plus 0.8ex minus 0.2ex}{1.3ex plus 0.2ex}
\titlespacing*{\subsection}
  {0pt}{1.3ex plus 0.5ex minus 0.2ex}{1.0ex plus 0.2ex}
\titlespacing*{\subsubsection}
  {0pt}{1.3ex plus 0.5ex minus 0.2ex}{1.0ex plus 0.2ex}

%TODO add this conditionally if option draft is given
\RequirePackage{lineno}

%% ***************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Document formating
%% ***************************************************************************

\definecolor{formblue}{rgb}{0.0,0.1,0.4}

\renewcommand\lstlistingname{Code}
\renewcommand\lstlistlistingname{Liste de Codes}
\lstset{%
  basicstyle=\ttfamily\footnotesize
}

\setcounter{secnumdepth}{4}

%% ***************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Numbering
%% ***************************************************************************

\newcounter{reaction}
\renewcommand\thereaction{R\,\thechapter.\arabic{reaction}}
\renewcommand\theequation{E\,\thechapter.\arabic{equation}}
\renewcommand\thefootnote{\roman{footnote}}
\@addtoreset{reaction}{chapter}
\@addtoreset{footnote}{chapter} 

%% ***************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Chemical reactions: Adapted from mhchem
%% ***************************************************************************

\newcommand\reactiontag{\refstepcounter{reaction}\tag{\thereaction}}
\newcommand\reaction@[2][]{\begin{equation}\ch{#2}%
  \ifx\@empty#1\@empty\else\label{#1}\fi\reactiontag\end{equation}}
\newcommand\reaction@nonumber[1]{\begin{equation*}\ch{#1}\end{equation*}}
\newcommand\reaction{\@ifstar{\reaction@nonumber}{\reaction@}}

%% ***************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Style whole table lines
%% ***************************************************************************

\newcolumntype{\$}{>{\global\let\currentrowstyle\relax}}
\newcolumntype{^}{>{\currentrowstyle}}
\newcommand{\rowstyle}[1]{\gdef\currentrowstyle{#1}#1\ignorespaces}

%% ***************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% French translations
%% ***************************************************************************

\addto\captionsfrench{%
  \renewcommand\contentsname{Sommaire}
  \renewcommand\tablename{Tableau}
}

\addto\extrasfrench{%
  \providecommand{\og}{\leavevmode\flqq~}%
  \providecommand{\fg}{\ifdim\lastskip>\z@\unskip\fi~\frqq}%
}

%% ***************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Other styles
%% ***************************************************************************

\let\newfootnoterule\footnoterule
\renewcommand*\footnoterule{\vfill\newfootnoterule}

\let\oldbibliography\bibliography
\def\bibliography#1{\part*{\bibname}\oldbibliography{#1}}

\renewcommand*\l@figure{\@dottedtocline{1}{1em}{3.2em}}
\let\l@table\l@figure

\renewcommand{\appendixtocname}{Annexes}
\renewcommand{\appendixpagename}{\appendixtocname}
\def\appendixpage{\part*{\appendixpagename}}
  
\onehalfspacing

%% ***************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Cover page
%% TODO there is a lot of testing to perform here and check for inputs
%% ***************************************************************************

\def\@logoschool{\@empty}
\def\@logocollege{\@empty}
\def\@logopartner{\@empty}
\def\@logolaboratory{\@empty}

\def\@college{\@empty}%
\def\@school{\@empty}%
\def\@domain{\@empty}%
\def\@jurytable{\@empty}

\def\logoschool#1{\gdef\@logoschool{\includegraphics[width=2cm]{#1}}}%
\def\logocollege#1{\gdef\@logocollege{\includegraphics[width=4cm]{#1}}}%
\def\logopartner#1{\gdef\@logopartner{\includegraphics[width=4cm]{#1}}}%
\def\logolaboratory#1{\gdef\@logolaboratory{\includegraphics[width=4cm]{#1}}}%

\def\college#1{\def\@college{#1}}%
\def\school#1{\def\@school{#1}}%
\def\domain#1{\def\@domain{#1}}%
\def\jurytable#1{\def\@jurytable{#1}}

\newcommand\makecoverpage{%
  \bookmark[page=1,level=0]{\xthesis@covername}
  \newgeometry{top=1cm,bottom=1cm,left=1cm,right=1cm}  
  \begin{titlepage}
    \centering
    \@logocollege\hfill\@logopartner\hfill\@logolaboratory\par\vspace*{12mm}
    \begin{minipage}{0.9\textwidth}
      \begin{center}
        {\large\expandafter\MakeUppercase\expandafter{\xthesis@these}
          \par\vspace*{5mm}}
        {\normalsize{\xthesis@for}\par\vspace*{5mm}}
        {\bfseries\normalsize\expandafter\MakeUppercase\expandafter{
          \xthesis@honor\ \xthesis@of\ \@college}\par\vspace*{5mm}}
        {\large{\@school}\par\vspace*{5mm}}
        {\@logoschool\par}
        {\normalfont\normalsize{\@domain}\par\vspace*{5mm}}
        {\normalfont\normalsize{\xthesis@presented}\par\vspace*{6mm}}
        {\bfseries\large{\@author}\par\vspace*{6mm}}
        {\rule{\textwidth}{2pt}\par
          \centering\Large\bfseries{\@title}\par
          \rule{\textwidth}{2pt}\par}
        %FIXME add date place arguments to release
    	\vspace*{3mm}{\footnotesize\xthesis@release}%\ \today.}
        \par\vspace*{0.6cm}
        \@jurytable
        %TODO add university and other info here
      \end{center}
      \null\vfill
    \end{minipage}
  \end{titlepage}
  \newgeometry{tmargin=2.5cm,bmargin=2.5cm,lmargin=2.5cm,rmargin=2.5cm}
  \newpage\thispagestyle{empty}\cleardoublepage
}

%% ***************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AtBeginDocument
%% ***************************************************************************

\AtBeginDocument{%
  \makecoverpage%

  \pagestyle{fancy}%

  \makeatletter
    \let\oldchapter\chapter
    \def\chapter{
      \pagestyle{fancy}
      \fancyhf{}
      \fancyhead[LE,RO]{\footnotesize\leftmark}
      \fancyhead[RE,LO]{\footnotesize\thepage}
      \fancyfoot[LE,RO]{\footnotesize\rightmark}
      \fancyfoot[RE,LO]{}
      \oldchapter
    }
  \makeatother
  
  % --------------------------------------------------------------------------
  % stackoverflow.com/questions/32310623/
  % --------------------------------------------------------------------------
  
  \fancypagestyle{plain}{
    \fancyhf{}
    \renewcommand{\headrulewidth}{0pt}
    \fancyfoot[RE,LO]{\footnotesize\thepage}
  }

  % --------------------------------------------------------------------------
  % Define thickness of rules
  % --------------------------------------------------------------------------
  
  \renewcommand{\headrulewidth}{1.0pt}
  \renewcommand{\footrulewidth}{0.5pt}
      
  % --------------------------------------------------------------------------
  % Table of contents
  % --------------------------------------------------------------------------
  
  \let\oldtableofcontents\tableofcontents
  \def\tableofcontents{%
    \setcounter{tocdepth}{2}
    \pdfbookmark{\contentsname}{\contentsname}
    {\singlespacing\oldtableofcontents}
  }
}

%% ***************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AtEndDocument
%% ***************************************************************************

%\AtEndDocument{%
%  \newpage\phantomsection
%  \pdfbookmark{\listfigurename}{\listfigurename}
%  {\singlespacing\listoffigures}
%  
%  \newpage\phantomsection
%  \pdfbookmark{\listtablename}{\listtablename}
%  {\singlespacing\listoftables}
%}

\endinput

%% ***************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF
%% ***************************************************************************
