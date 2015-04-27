{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}

module Yesod.GitRev.Data where

import Development.GitRev (gitHash, gitBranch, gitDirty)
import Language.Haskell.TH.Syntax (Lift(lift), Q, TExp, Exp, unsafeTExpCoerce)
import Yesod.Core hiding (lift)

data GitRev = GitRev
  { gitRevHash :: String
  , gitRevBranch :: String
  , gitRevDirty :: Bool
  }

mkYesodSubData "GitRev" [parseRoutes|
/ GitRevR GET
|]

instance Lift GitRev where
  lift GitRev{..} =
    [|
      GitRev
        { gitRevHash = $(lift gitRevHash)
        , gitRevBranch = $(lift gitRevBranch)
        , gitRevDirty = $(lift gitRevDirty)
        }
    |]

tGitRev :: Q (TExp GitRev)
tGitRev = unsafeTExpCoerce gitRev

gitRev :: Q Exp
gitRev =
  [|
    GitRev
      { gitRevHash = $gitHash
      , gitRevBranch = $gitBranch
      , gitRevDirty = $gitDirty
      }
  |]
