page 50026 "Plan List"
{

    ApplicationArea = All;
    Caption = 'Plan List';
    PageType = List;
    SourceTable = "Plan Header";
    UsageCategory = Lists;
    InsertAllowed = true;
    Editable = true;
    DeleteAllowed = false;
    CardPageId = "Plan Header Card";
    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                field("Plan Name"; "Plan Name")
                {
                    ApplicationArea = all;

                }
                field("Plan Description"; "Plan Description")
                {
                    ApplicationArea = all;
                }
                field("Plan Year"; "Plan Year")
                {
                    ApplicationArea = all;
                }
                field("Plan Month"; "Plan Month")
                {
                    ApplicationArea = all;
                }
                field("Plan Type"; "Plan Type")
                {
                    ApplicationArea = all;
                }
                field("Create Date"; "Create Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Create By"; "Create By")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Card)
            {
                ApplicationArea = all;
                Caption = 'Item Plan List';
                Image = Planning;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;
                trigger OnAction()
                var
                    ItemPlanList: page "List Item On Report";
                begin
                    Clear(ItemPlanList);
                    ItemPlanList.Run();
                end;
            }
        }
    }
}