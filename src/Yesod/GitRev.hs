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
import Yesod.Core
import Yesod.GitRev.Data

getGitRevR :: Yesod master => HandlerT GitRev (HandlerT master IO) TypedContent
getGitRevR = getYesod >>= \GitRev{..} -> lift $ selectRep $ do
  provideRep $ defaultLayout $ do
    [whamlet|
      <dl>
        <dt>Hash
        <dd>#{gitRevHash}
        <dt>Branch
        <dd>#{gitRevBranch}
        <dt>Dirty
        <dd>#{gitRevDirty}
    |]
  provideRep $ return $ object
    [ "hash"   .= gitRevHash
    , "branch" .= gitRevBranch
    , "dirty"  .= gitRevDirty
    ]

instance Yesod master => YesodSubDispatch GitRev (HandlerT master IO) where
  yesodSubDispatch = $(mkYesodSubDispatch resourcesGitRev)
