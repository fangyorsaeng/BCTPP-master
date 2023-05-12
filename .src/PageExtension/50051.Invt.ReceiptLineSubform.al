pageextension 50051 "Invt.Receipt Subform Ex" extends "Invt. Receipt Subform"
{
    layout
    {
        modify("Indirect Cost %") { Visible = false; }
        modify("Unit Cost") { Visible = false; }
        addafter(Description)
        {
            field("Reason Code"; "Reason Code")
            {
                Visible = true;
            }
        }
    }
}