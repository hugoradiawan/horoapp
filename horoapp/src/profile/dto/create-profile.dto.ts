import { IsArray, IsNumber, IsOptional, IsString } from 'class-validator';

export class CreateProfileDto {
  @IsString()
  readonly name?: string;
  @IsString()
  readonly birthday?: string;
  @IsString()
  readonly gender?: string;
  @IsNumber()
  readonly heightInCm?: number;
  @IsNumber()
  readonly weightInKg?: number;
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  readonly interests?: string[];
}
