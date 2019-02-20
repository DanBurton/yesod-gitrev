{-# LANGUAGE DeriveLift #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}

module Yesod.GitRev.Data where

import GitHash
import Language.Haskell.TH.Syntax (Lift, Q, TExp, Exp, unTypeQ)
import Yesod.Core

-- | You should not construct one of these yourself.
-- Instead, use gitRev or tGitRev.
-- Fields added to this record are treated as a minor version bump.
data GitRev = GitRev
  { gitRevHash :: String
  , gitRevBranch :: String
  , gitRevDirty :: Bool
  , gitRevCommitDate :: String
    -- ^ @since 0.2.1
  , gitRevCommitCount :: Int
    -- ^ @since 0.2.1
  , gitRevCommitMessage :: String
    -- ^ @since 0.2.1
  }
  deriving Lift

mkYesodSubData "GitRev" [parseRoutes|
/ GitRevR GET
|]

-- | A typed splice for creating a GitRev.
-- Example: $$(tGitRev) :: GitRev
tGitRev :: Q (TExp GitRev)
tGitRev = [|| gitRevFromGitInfo $$(tGitInfoCwd) ||]

-- | An untyped splice for creating a GitRev.
-- Example: $(gitRev) :: GitRev
gitRev :: Q Exp
gitRev = unTypeQ tGitRev

-- This function is considered to be "internal".
-- Changes to this function will not be accounted for in minor version bumps.
gitRevFromGitInfo :: GitInfo -> GitRev
gitRevFromGitInfo gi = GitRev
  { gitRevHash = giHash gi
  , gitRevBranch = giBranch gi
  , gitRevDirty = giDirty gi
  , gitRevCommitDate = giCommitDate gi
  , gitRevCommitCount = giCommitCount gi
  , gitRevCommitMessage = giCommitMessage gi
  }
