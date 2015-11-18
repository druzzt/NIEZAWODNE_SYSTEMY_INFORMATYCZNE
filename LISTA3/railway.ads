package Railway with SPARK_Mode is

   type One_Signal_State is (Red, Green);

   type Route_Type is (Route_Left_Middle,  -- lewy do srodkowego
                       Route_Middle_Right, -- srodkowy do prawego
                       Route_Right_Middle, -- prawy do srodkowego
                       Route_Middle_Left,  -- srodkowy do lewego
                       Route_Enter_Left,   -- wjazd z lewej
                       Route_Leave_Right,  -- wyjazd z prawej
                       Route_Enter_Right,  -- wjazd z prawej
                       Route_Leave_Left);  -- wyjazd z lewej

   type One_Segment_State is (Occupied_Standing,          -- zajety, stoi
                              Occupied_Moving_Left,       -- zajety, w lewo
                              Occupied_Moving_Right,      -- zajety, w prawo
                              Reserved_Moving_From_Left,  -- resvd, mv z lew
                              Reserved_Moving_From_Right, -- rsvd, mv z praw
                              Free);                      -- WOLNE

   type Segment_State_Type is
      record
         Left,   -- lewy segment
         Middle, -- srodkowy segment
         Right : One_Segment_State; -- prawy segment
      end record;

   type Signal_State_Type is
      record
         Left_Middle, -- lewy do srodkowego stan
         Middle_Left, -- srodkowy do lewego stan
         Middle_Right, -- srodkowy do prawego stan
         Right_Middle: One_Signal_State; -- prawy do srodkowego stan
      end record;

   Segment_State : Segment_State_Type := (others => Free); -- stan segmentu
   Signal_State  : Signal_State_Type  := (others => Red); -- stan sygnalizatora

   function Correct_Signals return Boolean
   is
     (
        (if Signal_State.Left_Middle = Green then
              Segment_State.Left = Occupied_Moving_Right and
                Segment_State.Middle = Reserved_Moving_From_Left) and then
        (if Signal_state.Middle_Left = Green then
              Segment_State.Middle = Occupied_Moving_Left and
                Segment_State.Left = Reserved_Moving_From_Right) and then
        (if Signal_state.Middle_Right = Green then
              Segment_State.Middle = Occupied_Moving_Right and
                Segment_State.Right = Reserved_Moving_From_Left) and then
        (if Signal_state.Right_Middle = Green then
              Segment_State.Right = Occupied_Moving_Left and
                Segment_State.Middle = Reserved_Moving_From_Right));

   function Correct_Segments return Boolean
   is
     (
        (if Segment_State.Left /= Reserved_Moving_From_Right then
              Signal_State.Middle_Left = Red) and
        (if Segment_State.Middle /= Reserved_Moving_From_Left then
              Signal_State.Left_Middle = Red) and
        (if Segment_State.Middle /= Reserved_Moving_From_Right then
              Signal_State.Right_Middle = Red) and
        (if Segment_State.Right /= Reserved_Moving_From_Left then
              Signal_State.Middle_Right = Red));


   procedure Open_Route (Route: in Route_Type; Success: out Boolean)
     with
       Global => (In_Out => (Segment_State, Signal_State)),
         Pre => Correct_Signals and Correct_Segments,
       Depends => ((Segment_State, Success) => (Route, Segment_State),
                   Signal_State => (Segment_State, Route, Signal_State)),
       Post => Correct_Signals and Correct_Segments;

   procedure Move_Train (Route: in Route_Type; Success: out Boolean)
     with
       Global => (In_Out => (Segment_State, Signal_State)),
         Pre => Correct_Signals and Correct_Segments,
       Depends => ((Segment_State, Success) => (Route, Segment_State),
                   Signal_State => (Segment_State, Route, Signal_State)),
       Post => Correct_Signals and Correct_Segments;

   --Just to Open_Route and then if possible Move_Train.
   procedure Train (Route : in Route_Type; retval : in out Boolean);


end Railway;
