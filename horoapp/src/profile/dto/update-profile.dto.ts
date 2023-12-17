import { IsArray, IsNumber, IsOptional, IsString } from 'class-validator';

export class UpdateProfileDto {
  @IsOptional()
  @IsString()
  readonly name?: string;

  @IsOptional()
  @IsString()
  readonly birthday?: string;

  @IsOptional()
  @IsNumber()
  readonly height?: string;

  @IsOptional()
  @IsNumber()
  readonly weight?: number;

  @IsOptional()
  @IsArray()
  readonly interest?: string[];
}
