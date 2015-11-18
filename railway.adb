--@Author Arkadiusz Lewandowski
--@LICENSING: MIT
--@DESCRIPTION: Railway package body for FORMAL VERIFICATION in ADA|SPARK
-- Train cannot move if his next step could potentialy be a crash
-- Open_Route is procedure which establishes availability of a route and sets signalisation
-- into proper colors.
-- Move_Train is procedure which moves Train on given route and sets back the signalisation.
package body Railway with SPARK_Mode is
   --Procedura Otwierajaca trase pociagu
   procedure Open_Route ( Route : in Route_Type; Success : out Boolean)
   is
   begin
          -- tutaj przygotowuje sobie trase i zamykam innym
      case Route is
         when Route_Enter_Left =>
           if Segment_State.Left = Free then -- bo chce wjechac
               Segment_State.Left := Reserved_Moving_From_Left;
               Signal_State.Middle_Left := Red;
               Success:=True;
           else
               Success:=False;
           end if;
         when Route_Enter_Right =>
            if Segment_State.Right = Free then -- bo chce wjechac
               Segment_State.Right := Reserved_Moving_From_Right;
               Success:=True;
            else
               Success:=False;
            end if;
         when Route_Leave_Left =>
            if Segment_State.Left = Occupied_Standing then --juz tam jest i chce wyjechac

               Segment_State.Left := Occupied_Moving_Left;
               Success:=True;
            else
               Success:=False;
            end if;
         when Route_Leave_Right =>
            if Segment_State.Right = Occupied_Standing then -- juz tam jest i chce wyjechac
               Segment_State.Right := Occupied_Moving_Right;
               Success:=True;
            else
               Success:=False;
            end if;
         when Route_Left_Middle =>
            if Segment_State.Middle = Free and Segment_State.Left = Occupied_Standing then
               Segment_State.Middle := Reserved_Moving_From_Left;
               Signal_State.Left_Middle := Green;
               Segment_State.Left := Occupied_Moving_Right; -- czy na pewno stoi?
               Success:=True;
            else
               Success:=False;
            end if;
         when Route_Middle_Left =>
            if Segment_State.Left = Free and Segment_State.Middle = Occupied_Standing then
               Segment_State.Left := Reserved_Moving_From_Right;
               Signal_State.Middle_Left := Green;
               Segment_State.Middle := Occupied_Moving_Left; -- czy na pewno stoi?
               Success:=True;
            else
               Success:=False;
            end if;
         when Route_Middle_Right =>
            if Segment_State.Right = Free and Segment_State.Middle = Occupied_Standing then
               Signal_State.Middle_Right:= Green;
               Segment_State.Middle := Occupied_Moving_Right; -- czy na pewno stoi? !!!
               Segment_State.Right := Reserved_Moving_From_Left;
               Success:=True;
            else
               Success:=False;
            end if;
         when Route_Right_Middle =>
            if Segment_State.Middle = Free and Segment_State.Right = Occupied_Standing then
               Signal_State.Right_Middle := Green;
               Segment_State.Right := Occupied_Moving_Left; -- czy na pewno stoi?
               Segment_State.Middle := Reserved_Moving_From_Right;
               Success:=True;
            else
                Success:=False;
            end if;
         when others =>
            Success:=False;
      end case;
   end Open_Route;

   --Procedura przepuszczajaca pociag
   procedure Move_Train ( Route :in Route_Type; Success : out Boolean)
   is
   begin

        case Route is

         when Route_Enter_Left =>
            if Segment_State.Left = Reserved_Moving_From_Left then -- bo chce wjechac
               Segment_State.Left := Occupied_Standing; -- no i stanal
               Signal_State.Middle_Left := Red;
               Success:=True;
           else
               Success:=False;
           end if;
         when Route_Enter_Right =>
            if Segment_State.Right = Reserved_Moving_From_Right then -- bo chce wjechac
               Segment_State.Right := Occupied_Standing; -- no i stanal
               Signal_State.Middle_Right := Red;
               Success:=True;
            else
               Success:=False;
            end if;
         when Route_Leave_Left =>
            if Segment_State.Left = Occupied_Moving_Left then
               Segment_State.Left := Free; -- no i wyjechal
               Signal_State.Middle_Left := Red;
               Signal_State.Left_Middle := Red;
               Success:=True;
            else
               Success:=False;
            end if;
         when Route_Leave_Right =>
            if Segment_State.Right = Occupied_Moving_Right then
               Segment_State.Right := Free; -- no i wyjechal
               Signal_State.Middle_Right := Red;
               Signal_State.Right_Middle := Red;
               Success:=True;
            else
               Success:=False;
            end if;
         when Route_Left_Middle =>
            if Segment_State.Middle = Reserved_Moving_From_Left and
              Segment_State.Left = Occupied_Moving_Right then
               Segment_State.Middle := Occupied_Standing;
               Signal_State.Left_Middle := Red;
               Segment_State.Left := Free; -- czy na pewno stoi?
               --Signal_State.Middle_Left := Red; -- bo tylko on moze wyjechac ze srodka
               Success:=True;
            else
               Success:=False;
            end if;
         when Route_Middle_Left =>
            if Segment_State.Left = Reserved_Moving_From_Right and
              Segment_State.Middle = Occupied_Moving_Left then
               Segment_State.Left := Occupied_Standing;
               Signal_State.Middle_Left := Red;
               Segment_State.Middle := Free; -- czy na pewno stoi?
               Success:=True;
            else
               Success:=False;
            end if;
         when Route_Middle_Right =>
            if Segment_State.Right = Reserved_Moving_From_Left and
              Segment_State.Middle = Occupied_Moving_Right then
               Segment_State.Right := Occupied_Standing;
               Segment_State.Middle := Free; -- czy na pewno stoi?
               Signal_State.Middle_Right := Red;
               Success:=True;
            else
               Success:=False;
            end if;
         when Route_Right_Middle =>
            if Segment_State.Middle = Reserved_Moving_From_Right and
              Segment_State.Right = Occupied_Moving_Left then
              Segment_State.Middle := Occupied_Standing;
               Segment_State.Right := Free; -- czy na pewno stoi?
               Signal_State.Right_Middle := Red;
               Success:=True;
            else
                Success:=False;
            end if;
         when others =>
            Success:=False;
         end case;
   end Move_Train;

   --Slight improvement in a write style
   procedure Train(Route: in Route_Type; retval : in out Boolean)
   is
   begin
     if Correct_Segments and Correct_Signals then
       Open_Route(Route, retval);
       if retval = True then Move_Train(Route, retval);
       else retval:=false;
       end if;
     end if;
   end Train;
end Railway;
