{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}

-- to run this file, from the root dir of this repo:
-- stack build
-- stack runghc examples/Main.hs
-- Then visit localhost:3000/build-version in your browser

import Yesod.Core
import Yesod.GitRev

data Master = Master
  { getGitRev :: GitRev
  }

mkYesod "Master" [parseRoutes|
/build-version GitRevR GitRev getGitRev
|]

instance Yesod Master

main = warp 3000 $ Master $$(tGitRev)
