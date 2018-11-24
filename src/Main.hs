module Main where

import           ClassyPrelude

import           Conduit
import           Control.Monad.Loops (whileJust_)
import           System.Exit         (die)

main :: IO ()
main = do
  args <- getArgs
  case readMay <$> args of
    [Just (count :: Int), Just (total :: Int)] -> do
      runConduit $ producer total .| rotateC count .| printC
      runConduit $ producer total .| rotateC_takeWhileC count .| printC
      runConduit $ producer total .| rotateC_whileJust_ count .| printC
    _ ->
      die "Invalid args. give rotating count and total count."

producer :: Monad m => Int -> ConduitT () Int m ()
producer total = traverse_ yield ([0..total - 1] :: [Int])

rotateC :: forall a m. Monad m => Int -> ConduitT a a m ()
rotateC n = do
  xs :: [a] <- catMaybes <$> replicateM n await
  mapC id
  yieldMany xs


rotateC_takeWhileC :: forall a m. Monad m => Int -> ConduitT a a m ()
rotateC_takeWhileC n = do
  xs :: [a] <- catMaybes <$> replicateM n await
  takeWhileC (const True)
  yieldMany xs

rotateC_whileJust_ :: forall a m. Monad m => Int -> ConduitT a a m ()
rotateC_whileJust_ n = do
  xs :: [a] <- catMaybes <$> replicateM n await
  whileJust_ await yield
  yieldMany xs
