{-# LANGUAGE DeriveLift #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}

module Yesod.GitRev.Data where

import GitHash (tGitInfoCwd, giHash, giBranch, giDirty, GitInfo)
import Language.Haskell.TH.Syntax (Lift, Q, TExp, Exp, unTypeQ)
import Yesod.Core

data GitRev = GitRev
  { gitRevHash :: String
  , gitRevBranch :: String
  , gitRevDirty :: Bool
  }
  deriving Lift

mkYesodSubData "GitRev" [parseRoutes|
/ GitRevR GET
|]

tGitRev :: Q (TExp GitRev)
tGitRev = [|| gitRevFromGitInfo $$(tGitInfoCwd) ||]

gitRev :: Q Exp
gitRev = unTypeQ tGitRev

-- | This function is considered to be "internal".
-- Use it at your own peril.
-- Changes to this function will not be accounted for in minor version bumps.
gitRevFromGitInfo :: GitInfo -> GitRev
gitRevFromGitInfo gi = GitRev
  { gitRevHash = giHash gi
  , gitRevBranch = giBranch gi
  , gitRevDirty = giDirty gi
  }
