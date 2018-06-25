{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module Yesod.GitRev
  ( GitRev (..)
  , gitRev
  , tGitRev
  ) where

import Data.Aeson
import GitHash
import Yesod.Core
import Yesod.Core.Types
import Yesod.GitRev.Data

getGitRevR :: Yesod site => SubHandlerFor GitRev site TypedContent
getGitRevR = getSubYesod >>= \GitRev{..} -> liftHandler $ selectRep $ do
  provideRep $ defaultLayout $ do
    [whamlet|
      <dl>
        <dt>Hash
        <dd>#{giHash gitRevInfo}
        <dt>Branch
        <dd>#{giBranch gitRevInfo}
        <dt>Dirty
        <dd>#{giDirty gitRevInfo}
    |]
  provideRep $ return $ object
    [ "hash"   .= giHash gitRevInfo
    , "branch" .= giBranch gitRevInfo
    , "dirty"  .= giDirty gitRevInfo
    ]

instance Yesod site => YesodSubDispatch GitRev site where
  yesodSubDispatch = $(mkYesodSubDispatch resourcesGitRev)
