tableextension 50003 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Cond: Record "Condition Template Customer";
            begin
                "Create Date" := CurrentDateTime;
                "Create By" := utility.UserFullName(UserId);
                "CRRNCY Initial Die Cost" := 'THB';
                "CRRNCY Price/Piece" := "CRRNCY Price/Piece"::Baht;

                //Get Condition//
                if "Sell-to Customer No." <> '' then begin
                    Cond.Reset();
                    Cond.SetRange("Condition Code", "Sell-to Customer No.");
                    if Cond.Find('-') then begin
                        repeat
                            case Cond."Seq." of
                                1:
                                    "Condition 1" := Cond.Detail;
                                2:
                                    "Condition 2" := Cond.Detail;
                                3:
                                    "Condition 3" := Cond.Detail;
                                4:
                                    "Condition 4" := Cond.Detail;
                                5:
                                    "Condition 5" := Cond.Detail;
                                6:
                                    "Condition 6" := Cond.Detail;
                                7:
                                    "Condition 7" := Cond.Detail;
                                8:
                                    "Condition 8" := Cond.Detail;
                                9:
                                    "Condition 9" := Cond.Detail;
                                10:
                                    "Condition 10" := Cond.Detail;
                            end;
                        until Cond.Next = 0;
                    end;
                end;


            end;
        }
        field(50000; "Create Date"; DateTime)
        {

        }
        field(50001; "Create By"; Text[50])
        {

        }
        field(50002; "Address 3"; Text[50])
        {

        }
        field(50003; "Drawing and Material"; Text[50])
        {

        }
        field(50004; "Remark HD"; Text[250])
        {

        }
        field(50005; "RE: Quotation for"; Text[100]) { }
        field(50015; "CRRNCY Initial Die Cost"; Code[20])
        {
            TableRelation = Currency.Code;
        }
        field(50016; "CRRNCY Price/Piece"; Option)
        {
            OptionMembers = Baht,USD,JPY,CNY;
        }
        field(50050; "BOI Code"; Code[20])
        {
            TableRelation = "BOI List";
        }
        field(50051; "Comercial"; Option)
        {
            OptionMembers = Comercial,NonComercial;
        }
        field(50052; "Phone No."; Text[20]) { }
        field(50053; "Fax No."; Text[20]) { }


        field(50055; "Condition 1"; Text[200]) { }
        field(50065; "Condition 2"; Text[200]) { }
        field(50057; "Condition 3"; Text[200]) { }
        field(50058; "Condition 4"; Text[200]) { }
        field(50059; "Condition 5"; Text[200]) { }
        field(50060; "Condition 6"; Text[200]) { }
        field(50061; "Condition 7"; Text[200]) { }
        field(50062; "Condition 8"; Text[200]) { }
        field(50063; "Condition 9"; Text[200]) { }
        field(50064; "Condition 10"; Text[200]) { }


        field(50200; "SAILING ON"; Code[30]) { }
        field(50201; "FROM Address"; Text[70]) { }
        field(50202; "TO Address"; Text[70]) { }
        field(50203; "FREIGHT"; Text[50]) { }
        field(50204; "INSURANCE"; Text[50]) { }
        field(50205; "FOB"; Text[50]) { }
        field(50206; "Company Bank"; Code[30])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(50207; "Shiping Mark"; Text[100]) { }
        field(50208; "Total Mark"; Text[100]) { }
        field(50209; "Dimension"; Text[50]) { }

        field(50250; "Billing No."; Code[30])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Billing Line"."Document No." where("Sale Invoice No." = field("No."), "Document Type" = filter("Sales Billing")));
        }
        field(50251; "Receipt No."; Code[30])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Billing Line"."Document No." where("Sale Invoice No." = field("No."), "Document Type" = filter("Sales Receipt")));
        }
        field(50252; "Filter Customer"; Boolean)
        {

        }
        field(50300; "Invoiced"; Boolean)
        {

        }


    }

    var
        utility: Codeunit Utility;

    procedure getCondition()
    begin

    end;
}