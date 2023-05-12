page 50029 "List Item On Report"
{
    Caption = 'Item Plan List';
    ApplicationArea = All;
    PageType = List;
    SourceTable = "List Item On Report";
    SourceTableView = sorting("Group Name", Seq, "Group PD", "Report Type", "Type Item", "Part No.", EntryNo);
    UsageCategory = Lists;
    InsertAllowed = true;
    Editable = true;
    DeleteAllowed = true;
    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                field("Group Name"; "Group Name")
                {
                    ApplicationArea = all;
                }
                field(Seq; Seq)
                {
                    ApplicationArea = all;
                }
                field("Part No."; "Part No.")
                {
                    ApplicationArea = all;

                }
                field("Part Name"; "Part Name")
                {
                    ApplicationArea = all;
                    // Editable = false;
                }
                field("Report Type"; "Report Type")
                {
                    ApplicationArea = all;
                    Visible = true;
                }
                field("Group PD"; "Group PD")
                {
                    ApplicationArea = all;
                }
                field("Type Item"; "Type Item")
                {
                    ApplicationArea = all;
                }
                field(Active; Active)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Editable; Editable)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}