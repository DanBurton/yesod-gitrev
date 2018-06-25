{-# LANGUAGE DeriveLift #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}

module Yesod.GitRev.Data where

import GitHash
import Language.Haskell.TH.Syntax (Lift(lift), Q, TExp, Exp, unsafeTExpCoerce, unTypeQ)
import Yesod.Core hiding (lift)

newtype GitRev = GitRev
  { gitRevInfo :: GitInfo
  }
  deriving Lift

mkYesodSubData "GitRev" [parseRoutes|
/ GitRevR GET
|]

tGitRev :: Q (TExp GitRev)
tGitRev = unsafeTExpCoerce gitRev

gitRev :: Q Exp
gitRev =
  [|
    GitRev
      { gitRevInfo = $(unTypeQ tGitInfoCwd)
      }
  |]
