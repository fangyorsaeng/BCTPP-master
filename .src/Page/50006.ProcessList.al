page 50006 "Process List"
{
    SourceTable = "Process List";
    PageType = List;
    Editable = true;
    ApplicationArea = all;
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Process Name"; "Process Name")
                {
                    ApplicationArea = all;
                }
                field("Process Type"; "Process Type")
                {
                    ApplicationArea = all;
                }
                field(Active; Active)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}