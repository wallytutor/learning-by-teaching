%% xreport.cls
%% Walter Dal'Maz Silva
%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{xreport}[2016/10/04 v0.1]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions
\LoadClass{report}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% add dots to chapters in TOC

%TODO implement this
%tex.stackexchange.com/questions/53898
%\RequirePackage{tocloft}
%  \renewcommand{\cftpartleader}{\cftdotfill{\cftdotsep}}
%  \renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}} 

%tex.stackexchange.com/questions/353206
\renewcommand{\@pnumwidth}{3.0em}

\renewcommand*\l@part[2]{%
  \ifnum \c@tocdepth >\m@ne
  \addpenalty{-\@highpenalty}%
  \vskip 0.8em \@plus\p@
  \setlength\@tempdima{1.5em}%
  \begingroup
    \parindent \z@ \rightskip \@pnumwidth
    \parfillskip -\@pnumwidth
    \leavevmode \bfseries
    \advance\leftskip\@tempdima
    \hskip -\leftskip
    #1\nobreak \leaders
    \hbox{$\m@th\mkern
      \@dotsep mu\hbox{.}\mkern \@dotsep mu$}
    \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
    \penalty\@highpenalty
  \endgroup
  \fi
}

\renewcommand*\l@chapter[2]{%
  \ifnum \c@tocdepth >\m@ne
  \addpenalty{-\@highpenalty}%
  \vskip 0.8em \@plus\p@
  \setlength\@tempdima{1.5em}%
  \begingroup
    \parindent \z@ \rightskip \@pnumwidth
    \parfillskip -\@pnumwidth
    \leavevmode \bfseries
    \advance\leftskip\@tempdima
    \hskip -\leftskip
    #1\nobreak \leaders
    \hbox{$\m@th\mkern
      \@dotsep mu\hbox{.}\mkern \@dotsep mu$}
    \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
    \penalty\@highpenalty
  \endgroup
  \fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Redefine chapter page

% Numbered chapter heading style
\renewcommand{\@makechapterhead}[1]{%
  {\singlespacing
    \parindent \z@ \raggedright \normalfont
    \rule{\textwidth}{1.5pt}  % horizontal line
    \vspace{5pt}        % add some vertical space
    \ifnum\c@secnumdepth>\m@ne
        \huge\scshape
        \@chapapp\space \thechapter
        \par\nobreak
    \fi
    \interlinepenalty\@M
    \huge \scshape \bf #1\par % chapter title
    \vspace{5pt} % add some vertical space
    \nobreak
    \vskip 45\p@
  }
}

% Unnumbered chapter heading style
\renewcommand{\@makeschapterhead}[1]{%
  {\singlespacing
    \parindent \z@ \raggedright \normalfont
    \rule{\textwidth}{1.5pt} % horizontal line
    \vspace{5pt} % add some vertical space
    \interlinepenalty\@M
    \huge \scshape \bf #1\par % chapter title
    \vspace{5pt}% add some vertical space
    \nobreak
    % tex.stackexchange.com/questions/233263
    % tex.stackexchange.com/questions/35680
    \markboth{\MakeUppercase{#1}}{\MakeUppercase{#1}}
    \vskip 45\p@
  }
}

%% redefine \chapter* so that \cleardoublepage
%%is not applied before and this can be suppressed
%\newcommand{\abstracthead}[1]{%
%  % use \thispagestyle{plain} to keep page
%  % with same style as chapter
%  \newpage\thispagestyle{plain}
%  \@makeschapterhead{#1}
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Redefine part page

\def\@makeparthead#1{%
  \vspace*{6pc}
  {\centering
    \ifnum\c@secnumdepth>\m@ne
        \Huge \scshape \partname \thepart \par
        \vspace{10\p@}
    \fi
    \rule{0.85\textwidth}{1.5pt} % horizontal line
    \singlespacing
    \huge\bf \expandafter{#1}\par
    \nobreak \vspace{20\p@}
  }
}

\def\@makesparthead#1{%
  \vspace*{6pc}
  {\centering
    \rule{0.85\textwidth}{1.5pt} % horizontal line
    \singlespacing
    \huge\bf \expandafter{#1}\par
    \nobreak \vspace{20\p@}
  }
}

\def\part{%
  \if@twoside\cleardoublepage\else\clearpage\fi
  %\if@openright\cleardoublepage%\else\clearpage\fi
  \thispagestyle{empty}
  \global\@topnum\z@
  \@afterindenttrue
  \secdef\@part\@spart
}

\def\@part[#1]#2{%
  \ifnum\c@secnumdepth>\m@ne
    \refstepcounter{part}%
    \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
  \else
    \addcontentsline{toc}{part}{#1}%
  \fi
  \addtocontents{lof}{\protect\addvspace{5\p@}}
  \addtocontents{lot}{\protect\addvspace{5\p@}}
  \if@twocolumn
    \@topnewpage[\@makeparthead{#2}]
  \else
    \@makeparthead{#2}
    \@afterheading
    \@endpart % adapted on 16/nov/2016
  \fi
}

\def\@spart#1{%
  \newpage\phantomsection
  \addcontentsline{toc}{part}{#1}
  \if@twocolumn
    \@topnewpage[\@makesparthead{#1}]
  \else
    \@makesparthead{#1}
    \@afterheading
    \@endpart % adapted on 16/nov/2016
  \fi
}

% adapted from:
% tex.stackexchange.com/questions/239120/
\def\@endpart{%
  \vfil\newpage
  \if@twoside
    %\if@openright
      \newpage
      \thispagestyle{empty}
      \cleardoublepage
    %\fi
  \fi
%  \if@twocolumn
%    \twocolumn
%  \fi
}

\endinput
