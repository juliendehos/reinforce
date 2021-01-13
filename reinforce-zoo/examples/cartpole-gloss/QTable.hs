module Main where

import Data.DList (toList)
import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Simulate
import System.Exit (exitSuccess)

import Control.MonadEnv (Reward)
import Data.CartPole (Action, StateCP)
import Data.Event (Event(..))
import Environments.Gym.ClassicControl.CartPoleV1
import Reinforce.Agents
import Reinforce.Agents.QTable
import Reinforce.Algorithms.QLearning

main :: IO ()
main = do
    x <- runDefaultEnvironment False
            $ runQTable defaultConfigs (Left 0.85)
            $ runLearner (Just 500) (Just 500) rolloutQLearning
            -- $ runLearner (Just 10) (Just 10) rolloutQLearning
            -- TODO render when learning
    case x of
        Left err -> print err
        Right events -> run (toList events)
        -- Right events -> print $ last (toList events)

run :: [Event Reward StateCP Action] -> IO ()
run events = simulateIO mode bgcolor fps events draw step
    where
        mode = InWindow "CartPoleV1" (2*round width2, 2*round height2) (100, 100)
        bgcolor = white
        fps = 30
        step _viewport _time [] = exitSuccess
        step _viewport _time _events = return $ tail _events

draw :: [Event Reward StateCP Action] -> IO Picture
draw [] = return blank
draw (Event i _ s _ : _) = do
    let x = scaleX * position s
        y = -0.5 * height2
        a = angle s
        -- a = 5 * angle s
    -- putStrLn $ "i = " ++ show i ++ ", x = " ++ show x ++ ", a = " ++ show a
    return $ Pictures
        [ translate 0 y trackPic
        , translate x y cartPic
        , translate x y $ rotate a polePic
        , textTransf $ Text $ "episode " ++ show i
        ]

polePic, cartPic, trackPic :: Picture
polePic = Color red $ Polygon [(-3,0), (-3,80), (3,80), (3,0)]
cartPic = Color black $ Polygon [(-20,-10), (-20,10), (20,10), (20,-10)]
trackPic = Color black $ Line [(-width2,0), (width2,0)]

textTransf :: Picture -> Picture
textTransf = translate (-width2 + 10) (height2 - 25) . scale 0.15 0.15

width2, height2, scaleX :: Float
width2 = 200
height2 = 100
scaleX = 100

-- https://gym.openai.com/envs/CartPole-v1/
-- https://sentenai.github.io/reinforce/index.html
-- stack build && stack exec qtable-cartpole-gloss-example

