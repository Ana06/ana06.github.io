%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This class file defines the structure and design of the template. 
%
% Original header:
% Copyright (C) 2010 by Trey Hunner
%
% Copying and distribution of this file, with or without modification,
% are permitted in any medium without royalty provided the copyright
% notice and this notice are preserved. This file is offered as-is,
% without any warranty.
%
% Created by Trey Hunner and modified by www.LaTeXTemplates.com
% and Ana María Martínez Gómez (http://anamaria.martinezgomez.name)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ProvidesClass{resume}[2010/07/10 v0.9 Resume class]

\LoadClass[11pt,letterpaper]{article} % Font size and paper type

\usepackage[parfill]{parskip} % Remove paragraph indentation
\usepackage{array} % Required for boldface (\bf and \bfseries) tabular columns
\usepackage{ifthen} % Required for ifthenelse statements

\pagestyle{empty} % Suppress page numbers
 \renewcommand{\baselinestretch}{0.9}
%----------------------------------------------------------------------------------------
%	HEADINGS COMMANDS: Commands for printing name and headingLine
%----------------------------------------------------------------------------------------

\def \name#1{\def\@name{#1}} % Defines the \name command to set name
\def \@name {} % Sets \@name to empty by default

\def \namesize#1{\def\@namesize{#1}} 
\def \@namesize {\huge} 
\def \nameskip#1{\def\@nameskip{#1}} 
\def \@nameskip {\smallskip}

\def \headingLineSep {$\diamond$} % Set default headingLine separator to a diamond

% One, two or three headingLine lines can be specified 
\let \@headingLineOne \relax
\let \@headingLinTtwo \relax
\let \@headingLineThree \relax

% \headingLine command can be used to set the first, second, and third heading lines (last 2 optional)
\def \headingLine #1{
  \@ifundefined{@headingLineOne}{
    \def \@headingLineOne {#1}
  }{
  \@ifundefined{@headingLineTwo}{
  \def \@headingLineTwo {#1}
  }{
     \def \@headingLineThree {#1}
  }}
}

% \printheadingLine is used to style an headingLine line (given as input)
\def \printheadingLine #1{
  \begingroup
    \def \\ {\headingLineSep\ }
    \centerline{#1}
  \endgroup
  \par
  \headingLineskip
}

% \printname is used to print the name as a page header
\def \printname {
  \begingroup
    \hfil{\MakeUppercase{\@namesize\bf \@name}}\hfil
    \@nameskip\break
  \endgroup
}

%----------------------------------------------------------------------------------------
%	PRINT THE HEADING LINES
%----------------------------------------------------------------------------------------

\let\ori@document=\document
\renewcommand{\document}{
  \ori@document  % Begin document
  \printname % Print the name specified with \name
  \@ifundefined{@headingLineOne}{}{ % Print the first headingLine if specified
    \printheadingLine{\@headingLineOne}}
  \@ifundefined{@headingLineTwo}{}{ % Print the second headingLine if specified
	\vspace{-0.1cm}
    \printheadingLine{\@headingLineTwo}}
  \@ifundefined{@headingLineThree}{}{ % Print the third headingLine if specified
	\vspace{-0.1cm}
    \printheadingLine{\@headingLineThree}}
	\vspace{-0.15cm}
}

 \renewcommand{\baselinestretch}{0.9}
%----------------------------------------------------------------------------------------
%	SECTION FORMATTING
%----------------------------------------------------------------------------------------

% Defines the rSection environment for the large sections within the CV
\newenvironment{rSection}[1]{ % 1 input argument - section name
  \sectionskip
  \MakeUppercase{\bf #1} % Section title
  \sectionlineskip
  \hrule % Horizontal line
}

%----------------------------------------------------------------------------------------
%	SUBSECTION FORMATTING
%----------------------------------------------------------------------------------------

\newcommand{\rSubsection}[8]{ % 4 input arguments - job title, date (optional), company name, location (optional), score (optional), details (optional) and details2 (optional)
  {\bf #1} \hfill {#2}
  \\
  { #3 \ifthenelse{\equal{#4}{}}{}{(#4)}} \hfill #5
  \ifthenelse{\equal{#6}{}}{}{
    \\ {\small $\cdot$ #6 }
    \ifthenelse{\equal{#7}{}}{}{
      \\ \vspace{-1em} % Break line for the \hfill to have effect
      \\ {\small $\cdot$ #7 }}
    \ifthenelse{\equal{#8}{}}{}{
      \\ \vspace{-1em} % Break line for the \hfill to have effect
      \\ {\small $\cdot$ #8 }}
    }
    \\ \vspace{-1.3em} % Break line for the \hfill to have effect
}

\newcommand{\rSubsectionTalk}[5]{ % 4 input arguments - talk title, url (optional), conference name, location (optional) and attendees (optional)
  {\bf #1} \ifthenelse{\equal{#5}{}}{}{- #5 attendees}
  \hfill
  \url{#2}
  \\ #3
  \ifthenelse{\equal{#4}{}}{}{(#4)}
  \\ \vspace{-1.3em} % Break line for the \hfill to have effect
}

\newcommand{\rSubsectionShort}[2]{ % Title and details (optional)
  {\bf #1} #2
  \\ \vspace{-1.3em} % Break line for the \hfill to have effect
}

\newenvironment{rSubsectionShortWithList}[2]{ % 2 input arguments - Title and details (optional)
  {\bf #1} #2 % Bold title, details
  \begin{list}{$\cdot$}{\leftmargin=0.4cm \labelsep=0.08cm} % \cdot used for bullets, no indentation
  \itemsep -0.8em \vspace{-0.8em} % Compress items in list together for aesthetics
  }{
  \end{list}\par
}

% The below commands define the whitespace after certain things in the document - they can be \smallskip, \medskip or \bigskip
\def\headingLineskip{\smallskip} % The space between the two headingLine (or phone/email) lines
\def\sectionlineskip{\smallskip} % The space above the horizontal line for each section 
\def\sectionskip{\smallskip} % The space after the heading section

