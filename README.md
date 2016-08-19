UNC CourseParse
===================

Currently hosting the 2016 fall courses.

## The Final File

You can download the file directly in ```output/UncCourses.json```.

Or you can just use [rawgit](http://rawgit.com/): https://cdn.rawgit.com/RuneBlaze/CourseParse/master/output/UncCourses.json.

## Synopsis

```haskell
courseParse :: Pdf -> Json
```

UNC CourseParse aims to do one job: it converts [UNC Registry's directory of classes](registrar.unc.edu/courses/schedule-of-classes/directory-of-classes-2/)
into a Json file.

The format, more specifically, can be said to be

```haskell
courseParse :: Pdf -> [Course]
data Course = Course {
  subject :: String,
  catalog_nbr :: String,
  section :: String,
  class_nbr :: String,
  title :: String,
  component :: String,
  units :: Int,
  bldg :: String,
  room :: String,
  days :: String,
  time :: String,
  instructor :: String,
  load :: String,
  rank :: String,
  attributes :: [String],
  enrl_cap :: Int,
  enrl_tot :: Int,
  wait_cap :: Int,
  wait_tot :: Int,
  prereqs :: String
}
```

I acknowledge that the JSON final design is inelegant, and will welcome any other efforts to help improve it.

I also acknowledge that the code is ugly, but I currently have no intention to improve it.

# Prerequisites

Ruby, ```pdf-reader``` gem, ```rake```.

# File requirement

Download the directory of classes to ```assets/courses.pdf```.

# Usage

 1. Clone the repo, enter it
 2. ```rake preprocess > assets/processed_courses.txt```
 3. ```ruby index.rb > output/foo-bar-whatever.json```

## So this is written in Ruby?

Yep.

## and the Haskell code there is doing what?

No idea.
