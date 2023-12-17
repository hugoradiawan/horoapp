import { IsArray, IsNumber, IsOptional, IsString } from 'class-validator';

export class CreateProfileDto {
  @IsString()
  readonly name?: string;
  @IsString()
  readonly birthday?: string;
  @IsNumber()
  readonly height?: number;
  @IsNumber()
  readonly weight?: number;
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  readonly interests?: string[];
}
