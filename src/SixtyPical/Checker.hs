-- encoding: UTF-8

module SixtyPical.Checker where

import SixtyPical.Model

allTrue = foldl (&&) True

trueOrDie message test =
    if test then True else error message

routineDeclared routName (Program _ routines) =
    elem routName (map (getRoutineName) routines)
    where
        getRoutineName (Routine name _) = name

getDeclLocationName (Assign name _ _) = name
getDeclLocationName (Reserve name _) = name

locationDeclared locName (Program decls _) =
    elem locName (map (getDeclLocationName) decls)
    where

routineUsedLocations (Routine _ instrs) = blockUsedLocations instrs

blockUsedLocations [] = []
blockUsedLocations (instr:instrs) =
    (instrUsedLocations instr) ++ blockUsedLocations instrs

instrUsedLocations (LOAD reg loc) = [loc]
instrUsedLocations (CMP reg loc) = [loc]
-- TODO: JSR...
instrUsedLocations (IFEQ b1 b2) =
    blockUsedLocations b1 ++ blockUsedLocations b2
instrUsedLocations _ = []

allRoutineLocationsDeclared program routine =
    allTrue (map (isDeclared) (routineUsedLocations routine))
    where
        isDeclared name = locationDeclared name program

allUsedLocationsDeclared p@(Program _ routines) =
    allTrue (map (allRoutineLocationsDeclared p) routines)

noDuplicateDecls p@(Program decls routines) =
    collectDecls decls []
    where
        collectDecls [] acc = True
        collectDecls (decl:decls) acc =
            if
                name `elem` acc
              then
                 error ("duplicate declaration '" ++ name ++ "'")
              else
                 collectDecls decls (name:acc)
            where
                name = getDeclLocationName decl

checkProgram program =
    trueOrDie "missing 'main' routine" (routineDeclared "main" program) &&
      trueOrDie "undeclared location" (allUsedLocationsDeclared program) &&
      noDuplicateDecls program
