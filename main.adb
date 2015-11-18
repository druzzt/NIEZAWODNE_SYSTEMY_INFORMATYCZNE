with Ada.Text_IO; use Ada.Text_IO;
with Railway; use Railway;

procedure Main is
   OK : Boolean;
   -- change TRYB to check for different possibilities of crash situation:
   -- TRYB = 0 => From Left to Right - no crash.
   -- TRYB = 1 => From Right to Left - no crash.
   -- TRYB = 2 => Simulated crash in the middle, RightTrain waits on middle for LeftTrain.
   -- TRYB = 3 => Train starts from Left, moves to the Middle, then back to Left,
   --             and then to the Middle, next to the Right, back to the Middle,
   --             and then again to the Right and at last Leaves at the right side the segments.
   TRYB : Integer := 3;
begin
   if TRYB = 0 then
   --Od lewej do prawej
   Put_Line("Normal -> Left -> Middle -> Right:");
   Open_Route ( Route_Enter_Left,   OK ); Put_Line(Boolean'Image(OK));
   Move_Train ( Route_Enter_Left,   OK ); Put_Line(Boolean'Image(OK));
   Open_Route ( Route_Left_Middle,  OK ); Put_Line(Boolean'Image(OK));
   Move_Train ( Route_Left_Middle,  OK ); Put_Line(Boolean'Image(OK));
   Open_Route ( Route_Middle_Right, OK ); Put_Line(Boolean'Image(OK));
   Move_Train ( Route_Middle_Right, OK ); Put_Line(Boolean'Image(OK));
   Open_Route ( Route_Leave_Right,  OK ); Put_Line(Boolean'Image(OK));
   Move_Train ( Route_Leave_Right,  OK ); Put_Line(Boolean'Image(OK));
elsif TRYB = 1 then
   -- A teraz w druga strone
   Put_Line("Normal -> Right -> Middle -> Left:");
   Open_Route ( Route_Enter_Right,   OK ); Put_Line(Boolean'Image(OK));
   Move_Train ( Route_Enter_Right,   OK ); Put_Line(Boolean'Image(OK));
   Open_Route ( Route_Right_Middle,  OK ); Put_Line(Boolean'Image(OK));
   Move_Train ( Route_Right_Middle,  OK ); Put_Line(Boolean'Image(OK));
   Open_Route ( Route_Middle_Left,   OK ); Put_Line(Boolean'Image(OK));
   Move_Train ( Route_Middle_Left,   OK ); Put_Line(Boolean'Image(OK));
   Open_Route ( Route_Leave_Left,    OK ); Put_Line(Boolean'Image(OK));
   Move_Train ( Route_Leave_Left,    OK ); Put_Line(Boolean'Image(OK));
elsif TRYB = 2 then
   -- A teraz wymuszone zderzenie
   Put_Line("Simulated crash  -> Right -> Middle");
   Put_Line("----------with-- -> Left  -> Middle:");
   Open_Route ( Route_Enter_Right,  OK ); Put_Line(Boolean'Image(OK));
   Move_Train ( Route_Enter_Right,  OK ); Put_Line(Boolean'Image(OK));
   Open_Route ( Route_Enter_Left,   OK ); Put_Line(Boolean'Image(OK));
   Move_Train ( Route_Enter_Left,   OK ); Put_Line(Boolean'Image(OK));
   Open_Route ( Route_Right_Middle, OK ); Put_Line(Boolean'Image(OK));
   Move_Train ( Route_Right_Middle, OK ); Put_Line(Boolean'Image(OK));
   Put_Line("RightTrain is now on Middle. LeftTrain aproaching Middle. Has trains crashed?");
   Open_Route ( Route_Left_Middle,  OK ); Put_Line(Boolean'Image(OK));
   Move_Train ( Route_Left_Middle,  OK ); Put_Line(Boolean'Image(OK));
   if OK=True then Put_Line("CRASH!");
   else Put_Line("TRAFFIC STOPPED, possibility of crash");
   end if;
   elsif TRYB = 3 then
      -- teraz kilka szybkich testow dwójkami
      Put_Line("Back and forth:");
      Put_Line("-> Left -> Middle");
      Train ( Route_Enter_Left, OK ); Put_Line(Boolean'Image(OK));
      Train ( Route_Left_Middle, OK ); Put_Line(Boolean'Image(OK));
      Put_Line("   Left <- Middle ");
      Train ( Route_Middle_Left, OK ); Put_Line(Boolean'Image(OK));
      Put_Line("   Left -> Middle -> Right");
      Train ( Route_Left_Middle, OK ); Put_Line(Boolean'Image(OK));
      Train ( Route_Middle_Right, OK ); Put_Line(Boolean'Image(OK));
      Put_Line("           Middle <- Right");
      Train ( Route_Right_Middle, OK ); Put_Line(Boolean'Image(OK));
      Put_Line("           Middle -> Right -> ");
      Train ( Route_Middle_Right, OK ); Put_Line(Boolean'Image(OK));
      Train ( Route_Leave_Right, OK ); Put_Line(Boolean'Image(OK));
      if OK = True then Put_Line("Train exited segments successfuly!");
      else Put_Line("Train met some problems");
         end if;
   elsif TRYB = 4 then
      null;
   else
      Put_Line("Podany tryb jest niepoprawny");
   end if;


end Main;
