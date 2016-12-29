module Scrollable
    exposing
        ( Scrollable
        , ScrollableBag
        , tickScrollable
        , tickScrollableBag
        , createScrollable
        , createScrollableBag
        )

import Array


type alias Scrollable a =
    { title : String
    , items : List a
    , page : Int
    , timer : Int
    , cycles : Int
    }


createScrollable : String -> List a -> Scrollable a
createScrollable title items =
    Scrollable title items 0 0 0


type alias ScrollableBag a =
    { items : List (Scrollable a)
    , page : Int
    , timer : Int
    , cycles : Int
    }


createScrollableBag : List (Scrollable a) -> ScrollableBag a
createScrollableBag items =
    ScrollableBag items 0 0 0


tickScrollable : Scrollable a -> Int -> Int -> Scrollable a
tickScrollable scrollable maxTimer maxItems =
    if scrollable.timer >= maxTimer then
        let
            itemsLen =
                List.length scrollable.items

            lastPage =
                (itemsLen // (maxItems + 1))

            ( newPage, cycles ) =
                if scrollable.page == lastPage then
                    ( 0, scrollable.cycles + 1 )
                else
                    ( scrollable.page + 1, scrollable.cycles )
        in
            { scrollable | timer = 0, cycles = cycles, page = newPage }
    else
        { scrollable | timer = scrollable.timer + 1 }


tickScrollableBag : ScrollableBag a -> Int -> Int -> ScrollableBag a
tickScrollableBag bag maxTimer maxItems =
    let
        itemsArray =
            Array.fromList bag.items

        itemsLength =
            Array.length itemsArray
    in
        case (Array.get bag.page itemsArray) of
            Just item ->
                let
                    currItemCycles =
                        item.cycles

                    itemsHead =
                        List.take bag.page bag.items

                    itemsTail =
                        List.drop (bag.page + 1) bag.items

                    tickedItem =
                        tickScrollable item maxTimer maxItems

                    afterItemCycles =
                        tickedItem.cycles

                    newItems =
                        itemsHead ++ [ tickedItem ] ++ itemsTail

                    newPage =
                        if currItemCycles == afterItemCycles then
                            bag.page
                        else
                            (bag.page + 1) % itemsLength

                    newCycles =
                        if newPage == 0 then
                            if bag.page > 0 then
                                bag.cycles + 1
                            else
                                bag.cycles
                        else
                            bag.cycles
                in
                    { bag | items = newItems, page = newPage, cycles = newCycles }

            Nothing ->
                bag
